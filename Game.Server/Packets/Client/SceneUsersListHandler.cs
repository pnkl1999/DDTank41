using Game.Base.Packets;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler(69, "用户列表")]
	public class SceneUsersListHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			GSPacketIn gSPacketIn = packet.Clone();
			gSPacketIn.ClearContext();
			byte b = packet.ReadByte();
			byte b2 = packet.ReadByte();
			GamePlayer[] allPlayersNoGame = WorldMgr.GetAllPlayersNoGame();
			int num = allPlayersNoGame.Length;
			byte b3 = ((num > b2) ? b2 : ((byte)num));
			gSPacketIn.WriteByte(b3);
			for (int i = b * b2; i < b * b2 + b3; i++)
			{
				GamePlayer gamePlayer = allPlayersNoGame[i % num];
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.ID);
				gSPacketIn.WriteString((gamePlayer.PlayerCharacter.NickName == null) ? "" : gamePlayer.PlayerCharacter.NickName);
				gSPacketIn.WriteByte(gamePlayer.PlayerCharacter.typeVIP);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.VIPLevel);
				gSPacketIn.WriteBoolean(gamePlayer.PlayerCharacter.Sex);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Grade);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.ConsortiaID);
				gSPacketIn.WriteString((gamePlayer.PlayerCharacter.ConsortiaName == null) ? "" : gamePlayer.PlayerCharacter.ConsortiaName);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Offer);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Win);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Total);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Escape);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Repute);
				gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.FightPower);
			}
			client.Out.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
