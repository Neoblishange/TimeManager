import moment from "moment";
import UserProvider from "../store/User";
import Clock from "../types/Clock";
import Fetcher from "./fetcher/fetcher";
import Response from "./fetcher/response";

class ClockAPI {
  public static getCurrentClock = async (): Promise<Response<Clock>> => {
    const user = new UserProvider();
    return Fetcher.get<Clock>(`clocks/${user.getID()}`);
  };

  public static setClockingOn = async (): Promise<Response<string>> => {
    const user = new UserProvider();
    return Fetcher.post<string>(`clocks/${user.getID()}`, {
      clock: {
        time: moment().utc(),
        status: true,
      },
    });
  };

  public static setClockingOff = async (): Promise<Response<string>> => {
    const user = new UserProvider();
    return Fetcher.post<string>(`clocks/${user.getID()}`, {
      clock: {
        time: moment().utc(),
        status: false,
      },
    });
  };
}

export default ClockAPI;
