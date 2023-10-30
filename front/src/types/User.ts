import EUserRole from "./EUserRole";
import Team from "./Team";

type User = {
  id: string;
  email: string;
  authToken: string;
  username: string;
  roles: EUserRole[];
  team: undefined | Team;
};

export default User;