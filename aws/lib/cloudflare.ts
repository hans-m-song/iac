import axios, { AxiosInstance } from "axios";

export namespace Cloudflare {
  export interface ResponseMessageObject {
    code: string;
    message: string;
  }

  export interface APIResult<T> {
    result: T;
    success: boolean;
    errors: ResponseMessageObject[];
    messages: ResponseMessageObject[];
  }

  export interface DNSRecord {
    id: string;
    name: string;
    type: string;
    content: string;
    proxied?: boolean;
    ttl: number;
  }

  export type DNSRecordAddResult = APIResult<DNSRecord>;
  export type DNSRecordEditResult = APIResult<DNSRecord>;
  export type DNSRecordBrowseResult = APIResult<DNSRecord[]>;
  export type DNSRecordDelResult = APIResult<DNSRecord>;
}

export class Cloudflare {
  private instance: AxiosInstance;

  constructor(options: { token: string }) {
    this.instance = axios.create({
      baseURL: "https://api.cloudflare.com/client/v4",
      headers: { Authorization: `Bearer ${options.token}` },
    });

    this.instance.interceptors.response.use(undefined, (error) => {
      if (!axios.isAxiosError(error)) {
        return Promise.reject(error);
      }

      const sanitised = JSON.stringify(error, (key, value) => {
        if (key === "Authorization") {
          return "REDACTED";
        }

        if (key === "stack" && typeof value === "string") {
          return value.split("\n").map((line) => line.trim());
        }

        return value;
      });

      return Promise.reject({
        error: JSON.parse(sanitised),
        response: error.response?.data,
      });
    });
  }

  async addDNSRecord(
    zoneId: string,
    record: Omit<Cloudflare.DNSRecord, "id">,
  ): Promise<Cloudflare.DNSRecordAddResult> {
    const response = await this.instance.post<Cloudflare.DNSRecordAddResult>(
      `/zones/${zoneId}/dns_records`,
      record,
    );

    return response.data;
  }

  async editDNSRecord(
    zoneId: string,
    recordId: string,
    record: Omit<Cloudflare.DNSRecord, "id">,
  ): Promise<Cloudflare.DNSRecordEditResult> {
    const response = await this.instance.put<Cloudflare.DNSRecordEditResult>(
      `/zones/${zoneId}/dns_records/${recordId}`,
      record,
    );

    return response.data;
  }

  async upsertDNSRecord(
    zoneId: string,
    record: Omit<Cloudflare.DNSRecord, "id">,
  ): Promise<Cloudflare.DNSRecordAddResult | Cloudflare.DNSRecordEditResult> {
    const response = await this.browseDNSRecords(zoneId, {
      type: record.type,
      name: record.name,
    });

    if (response.result.length === 0) {
      return this.addDNSRecord(zoneId, record);
    }

    const existingRecord = response.result[0];
    return this.editDNSRecord(zoneId, existingRecord.id, record);
  }

  async browseDNSRecords(
    zoneId: string,
    filters?: { type?: string; name?: string },
  ): Promise<Cloudflare.DNSRecordBrowseResult> {
    const response = await this.instance.get<Cloudflare.DNSRecordBrowseResult>(
      `/zones/${zoneId}/dns_records`,
      { params: filters },
    );

    return response.data;
  }

  async delDNSRecord(
    zoneId: string,
    recordId: string,
  ): Promise<Cloudflare.DNSRecordDelResult> {
    const response = await this.instance.delete<Cloudflare.DNSRecordDelResult>(
      `/zones/${zoneId}/dns_records/${recordId}`,
    );

    return response.data;
  }
}
