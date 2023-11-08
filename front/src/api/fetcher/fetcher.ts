import axios, { AxiosError, AxiosResponse, HttpStatusCode } from "axios";
import UserProvider from "../../store/User";
import Response from "./response";
const envVars = import.meta.env;

class Fetcher {
  private static URL =
    (envVars.VITE_ENV === "DEV"
      ? envVars.VITE_URL_DEV
      : envVars.VITE_URL_PROD) + envVars.VITE_BASE_URI;

  public static async get<T>(
    uri: string,
    params: object = {},
    headers: object = {},
    isAuth = true
  ): Promise<Response<T>> {
    // Build request
    const finalUri = this.buildURL(uri, params);
    const finalHeaders = this.getFinalHeaders(headers, isAuth);

    try {
      // Make request
      const axiosResponse = await axios.get(finalUri, {
        headers: finalHeaders,
      });

      // Return custom response
      return this.formatResponse(axiosResponse, true);
    } catch (error) {
      // Handle custom error response
      return this.handleError<T>(error as AxiosError);
    }
  }

  public static async post<T>(
    uri: string,
    params: object = {},
    headers: object = {},
    isAuth = true
  ): Promise<Response<T>> {
    // Build request"
    const finalUri = this.buildURL(uri, {});
    const finalHeaders = this.getFinalHeaders(headers, isAuth);
    try {
      // Make request
      const axiosResponse = await axios.post(finalUri, params, {
        headers: finalHeaders,
      });

      // Return custom response
      return this.formatResponse(axiosResponse);
    } catch (error) {
      // Handle custom error response
      return this.handleError<T>(error as AxiosError);
    }
  }

  public static async patch<T>(
    uri: string,
    params: object = {},
    headers: object = {},
    isAuth = true
  ): Promise<Response<T>> {
    // Build request
    const finalUri = this.buildURL(uri, {});
    const finalHeaders = this.getFinalHeaders(headers, isAuth);

    try {
      // Make request
      const axiosResponse = await axios.patch(finalUri, params, {
        headers: finalHeaders,
      });

      // Return custom response
      return this.formatResponse(axiosResponse);
    } catch (error) {
      // Handle custom error response
      return this.handleError<T>(error as AxiosError);
    }
  }

  public static async put<T>(
    uri: string,
    params: object = {},
    headers: object = {},
    isAuth = true
  ): Promise<Response<T>> {
    // Build request
    const finalUri = this.buildURL(uri, {});
    const finalHeaders = this.getFinalHeaders(headers, isAuth);

    try {
      // Make request
      const axiosResponse = await axios.put(finalUri, params, {
        headers: finalHeaders,
      });

      // Return custom response
      return this.formatResponse(axiosResponse);
    } catch (error) {
      // Handle custom error response
      return this.handleError<T>(error as AxiosError);
    }
  }

  public static async delete<T>(
    uri: string,
    params: object = {},
    headers: object = {},
    isAuth = true
  ): Promise<Response<T>> {
    // Build request
    const finalUri = this.buildURL(uri, params);
    const finalHeaders = this.getFinalHeaders(headers, isAuth);

    try {
      // Make request
      const axiosResponse = await axios.delete(finalUri, {
        headers: finalHeaders,
      });

      // Return custom response
      return this.formatResponse(axiosResponse);
    } catch (error) {
      // Handle custom error response
      return this.handleError<T>(error as AxiosError);
    }
  }

  private static getFinalHeaders(headers: object, isAuth: boolean): object {
    let finalHeaders = { ...headers };

    const user = new UserProvider();

    if (isAuth) {
      finalHeaders = { Authorization: `Bearer ${user.getToken()}`, ...headers };
    }
    return finalHeaders;
  }

  private static buildURL(pathname: string, search: object) {
    return this.URL + pathname + this.buildURLParamsFromObject(search);
  }

  private static isRequestSuccess = (code: number): boolean => {
    return code >= 200 && code < 300;
  };

  private static formatResponse<T>(
    axiosResponse: AxiosResponse<any, any>,
    noMessage = false
  ): Response<T> {
    const data = axiosResponse.data.data ?? axiosResponse.data;

    if (noMessage) {
      return {
        ok: this.isRequestSuccess(axiosResponse.status),
        code: axiosResponse.status,
        data,
      };
    }

    return {
      ok: this.isRequestSuccess(axiosResponse.status),
      message: axiosResponse.statusText,
      code: axiosResponse.status,
      data,
    };
  }

  private static buildURLParamsFromObject(params: object): string {
    if (Object.keys(params).length > 0) {
      const strParams: Record<string, string> = {};
      for (const [key, value] of Object.entries(params)) {
        if (value?.toString()?.length > 0) {
          strParams[key] = value.toString();
        }
      }
      return "?" + new URLSearchParams(strParams).toString();
    }
    return "";
  }

  private static handleError<T>(error: AxiosError): Promise<Response<T>> {
    const message = (error.response?.data as any).message;

    if (error.response)
      return Promise.reject({
        message,
        ok: false,
        code: error.response.status,
      });
    return Promise.reject({
      message: error.message,
      ok: false,
      code: HttpStatusCode.InternalServerError,
    });
  }
}

export default Fetcher;
