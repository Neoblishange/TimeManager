import moment from "moment";
import UserProvider from "../store/User";
import WorkingTimes from "../types/WorkingTimes";
import Fetcher from "./fetcher/fetcher";
import Response from "./fetcher/response";

class WorkingTimesAPI {
  public static list = async (): Promise<Response<WorkingTimes[]>> => {
    const user = new UserProvider();
    const yesterday = moment().subtract(1, "day").format("YYYY-MM-DD HH:mm:ss");
    const tomorrow = moment().add(1, "day").format("YYYY-MM-DD HH:mm:ss");

    return Fetcher.get<WorkingTimes[]>(
      "workingtimes/" +
        user.getID() +
        "?start=" +
        yesterday +
        "&end=" +
        tomorrow
    );
  };

  public static add = async (
    startDate: Date,
    endDate: Date
  ): Promise<Response<WorkingTimes>> => {
    const user = new UserProvider();
    const start = moment(startDate).format("YYYY-MM-DD HH:mm:ss");
    const end = moment(endDate).format("YYYY-MM-DD HH:mm:ss");

    return Fetcher.post("workingtimes/" + user.getID(), {
      workingtime: { start, end },
    });
  };
}

export default WorkingTimesAPI;
