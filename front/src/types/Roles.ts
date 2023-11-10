import RolesAPI, { IRole } from "../api/roles.api";

class Role {
  public static EMPLOYEE: string = "";
  public static MANAGER: string = "";
  public static DIRECTOR: string = "";

  constructor() {}

  public static async initRoles() {
    await RolesAPI.getAllRoles().then((res) => {
      this.parse(res.data);
      this.save();
    });
  }

  private static parse(roles: IRole[]) {
    this.EMPLOYEE = roles.find((r) => r.name === "employee")?.id ?? "";
    this.MANAGER = roles.find((r) => r.name === "manager")?.id ?? "";
    this.DIRECTOR = roles.find((r) => r.name === "director")?.id ?? "";
  }

  public static load() {
    const roles = JSON.parse(localStorage.getItem("roles") ?? "[]");
    this.parse(roles);
  }

  private static save() {
    const rolesLS: IRole[] = [
      {
        id: this.EMPLOYEE,
        name: "employee",
      },
      {
        id: this.MANAGER,
        name: "manager",
      },
      {
        id: this.DIRECTOR,
        name: "director",
      },
    ];

    localStorage.setItem("roles", JSON.stringify(rolesLS));
  }
}

export default Role;
