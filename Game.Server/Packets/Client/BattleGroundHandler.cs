using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(132, "场景用户离开")]
	public class BattleGroundHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			byte b = packet.ReadByte();
			_ = client.Player.BattleData.LevelLimit;
			GSPacketIn gSPacketIn = new GSPacketIn(132, client.Player.PlayerCharacter.ID);
			switch (b)
			{
			case 3:
			{
				byte b2 = packet.ReadByte();
				gSPacketIn.WriteByte(3);
				gSPacketIn.WriteBoolean(val: true);
				gSPacketIn.WriteByte(b2);
				switch (b2)
				{
				case 2:
					gSPacketIn.WriteInt(client.Player.BattleData.GetRank());
					break;
				case 1:
					if (client.Player.BattleData.MatchInfo == null)
					{
						gSPacketIn.WriteInt(0);
						gSPacketIn.WriteInt(0);
						gSPacketIn.WriteInt(client.Player.BattleData.fairBattleDayPrestige);
					}
					else
					{
						gSPacketIn.WriteInt(client.Player.BattleData.MatchInfo.addDayPrestge);
						gSPacketIn.WriteInt(client.Player.BattleData.MatchInfo.totalPrestige);
						gSPacketIn.WriteInt(client.Player.BattleData.fairBattleDayPrestige);
					}
					break;
				}
				client.Player.Out.SendTCP(gSPacketIn);
				break;
			}
			case 5:
				gSPacketIn.WriteByte(5);
				gSPacketIn.WriteInt(client.Player.BattleData.Attack);
				gSPacketIn.WriteInt(client.Player.BattleData.Defend);
				gSPacketIn.WriteInt(client.Player.BattleData.Agility);
				gSPacketIn.WriteInt(client.Player.BattleData.Lucky);
				gSPacketIn.WriteInt(client.Player.BattleData.Damage);
				gSPacketIn.WriteInt(client.Player.BattleData.Guard);
				gSPacketIn.WriteInt(client.Player.BattleData.Blood);
				gSPacketIn.WriteInt(client.Player.BattleData.Energy);
				client.Player.Out.SendTCP(gSPacketIn);
				break;
			}
			return 0;
        }
    }
}
