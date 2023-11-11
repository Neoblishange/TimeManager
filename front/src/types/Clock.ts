import User from "./User";

type Clock = {
  id: string;
  status: boolean;
  time: string;
  user: User;
};

export default Clock;
