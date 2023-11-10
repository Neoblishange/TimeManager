import RolesAPI from "../api/roles.api";

class Role {
  public static EMPLOYEE: string = "";
  public static MANAGER: string = "";
  public static DIRECTOR: string = "";

  constructor() {}

  public static async initRoles() {
    await RolesAPI.getAllRoles().then((res) => {
      console.log("res", res.data);
      this.EMPLOYEE = res.data.find((r) => r.name === "employee")?.id ?? "";
      this.MANAGER = res.data.find((r) => r.name === "manager")?.id ?? "";
      this.DIRECTOR = res.data.find((r) => r.name === "director")?.id ?? "";
    });
  }
}
export default Role;
