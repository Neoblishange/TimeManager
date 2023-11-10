import Team from "./Team";

type User = {
  id: string;
  email: string;
  authToken: string;
  username: string;
  roles: string[];
  team: undefined | Team;
};

export default User;

export interface UserLogin {
  email: string;
  id: string;
  roles: string[];
  username: string;
  token: string;
}
