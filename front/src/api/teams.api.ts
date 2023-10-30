import Team from "../types/Team";
import User from "../types/User";
import Fetcher from "./fetcher/fetcher";
import Response from "./fetcher/response";

class TeamsAPI {
  public static getAllTeams = async (): Promise<Response<Team[]>> =>
    Fetcher.get<Team[]>("teams");

  public static getTeamWithID = async (id: string): Promise<Response<Team>> =>
    Fetcher.get<Team>("teams/" + id);

  public static createTeam = async (
    name: string,
    idManager: string
  ): Promise<Response<Team>> =>
    Fetcher.post("teams", {
      team: {
        name,
        manager_id: idManager,
      },
    });

  public static addUserToTeam = async (
    idUser: string,
    idTeam: string
  ): Promise<Response<Team>> => Fetcher.post(`teams/${idUser}/${idTeam}`);

  public static changeTeamName = async (
    name: string,
    id: string
  ): Promise<Response<Team>> => Fetcher.put(`teams/${id}`, { team: { name } });

  public static deleteTeam = async (id: string): Promise<Response<Team>> =>
    Fetcher.delete(`teams/${id}`);

  public static teamUsers = async (id: string): Promise<Response<User[]>> =>
    Fetcher.get(`teams/${id}/users`);
}

export default TeamsAPI;
