import moment from "moment";
import UserProvider from "../store/User";
import WorkingTime from "../types/WorkingTimes";
import Fetcher from "./fetcher/fetcher";
import Response from "./fetcher/response";

class WorkingTimesAPI {
  public static getWorkingTimes = async (): Promise<
    Response<WorkingTime[]>
  > => {
    const user = new UserProvider();
    const start = moment()
      .subtract(10, "years")
      .utc()
      .format("YYYY-MM-DD HH:mm:ss");
    const end = moment().add(10, "years").utc().format("YYYY-MM-DD HH:mm:ss");

    return Fetcher.get<WorkingTime[]>(
      "workingtimes/" + user.getID() + "?start=" + start + "&end=" + end
    );
  };

  public static getWorkingTimesWithParams = async (
    start: Date,
    end: Date,
    userID?: string
  ): Promise<Response<WorkingTime[]>> => {
    const user = new UserProvider();

    return Fetcher.get<WorkingTime[]>(
      "workingtimes/" +
        (userID ?? user.getID()) +
        "?start=" +
        moment(start).format("YYYY-MM-DD HH:mm:ss") +
        "&end=" +
        moment(end).format("YYYY-MM-DD HH:mm:ss")
    );
  };
  public static getOne = (
    workingTimeID: string
  ): Promise<Response<WorkingTime>> => {
    const user = new UserProvider();
    return Fetcher.get("workingtimes/" + user.getID() + "/" + workingTimeID);
  };

  public static create = async (
    startDate: Date,
    endDate: Date
  ): Promise<Response<WorkingTime>> => {
    const user = new UserProvider();
    const start = moment(startDate).format("YYYY-MM-DD HH:mm:ss");
    const end = moment(endDate).format("YYYY-MM-DD HH:mm:ss");

    return Fetcher.post("workingtimes/" + user.getID(), {
      workingtime: { start, end },
    });
  };

  public static update = async (
    workingTime: WorkingTime
  ): Promise<Response<WorkingTime>> => {
    const start = moment(workingTime.start).format("YYYY-MM-DD HH:mm:ss");
    const end = moment(workingTime.end).format("YYYY-MM-DD HH:mm:ss");

    return Fetcher.put("workingtimes/" + workingTime.id, {
      workingtime: { start, end },
    });
  };

  public static delete = async (
    workingTime: WorkingTime
  ): Promise<Response<WorkingTime>> =>
    Fetcher.delete("workingtimes/" + workingTime.id);
}

export default WorkingTimesAPI;
