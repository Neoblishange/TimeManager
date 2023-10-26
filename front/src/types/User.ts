import EUserRole from "./EUserRole";

type User = {
  id: string;
  email: string;
  authToken: string;
  username: string;
  roles: EUserRole[];
};

export default User;
