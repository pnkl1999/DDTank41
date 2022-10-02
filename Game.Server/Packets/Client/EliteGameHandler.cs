using Game.Base.Packets;
using Game.Logic;
using SqlDataProvider.Data;
using System.Collections.Generic;
using System.Linq;

namespace Game.Server.Packets.Client
{
    [PacketHandler(162, "添加拍卖")]
    public class EliteGameHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            switch (packet.ReadByte())
            {
                case 1:
                    {
                        GSPacketIn gSPacketIn3 = new GSPacketIn(162);
                        gSPacketIn3.WriteByte(1);
                        gSPacketIn3.WriteInt(ExerciseMgr.EliteStatus);
                        client.Out.SendTCP(gSPacketIn3);
                        break;
                    }
                case 2:
                    if (ExerciseMgr.EliteStatus == 5 && client.Player.PlayerCharacter.Grade >= 30)
                    {
                        client.Out.SendEliteGameStartRoom();
                    }
                    break;
                case 3:
                    {
                        GSPacketIn gSPacketIn2 = new GSPacketIn(162);
                        gSPacketIn2.WriteByte(3);
                        gSPacketIn2.WriteInt(client.Player.PlayerCharacter.EliteRank);
                        gSPacketIn2.WriteInt(client.Player.PlayerCharacter.EliteScore);
                        client.Out.SendTCP(gSPacketIn2);
                        break;
                    }
                case 4:
                    {
                        int param = packet.ReadInt();
                        List<PlayerEliteGameInfo> list = ExerciseMgr.EliteGameChampionPlayersList.Where(delegate (KeyValuePair<int, PlayerEliteGameInfo> a)
                        {
                            KeyValuePair<int, PlayerEliteGameInfo> keyValuePair2 = a;
                            return keyValuePair2.Value.GameType == param;
                        }).Select(delegate (KeyValuePair<int, PlayerEliteGameInfo> a)
                        {
                            KeyValuePair<int, PlayerEliteGameInfo> keyValuePair = a;
                            return keyValuePair.Value;
                        }).ToList();
                        GSPacketIn gSPacketIn = new GSPacketIn(162);
                        gSPacketIn.WriteByte(4);
                        gSPacketIn.WriteInt(param);
                        gSPacketIn.WriteInt(list.Count);
                        foreach (PlayerEliteGameInfo item in list)
                        {
                            gSPacketIn.WriteInt(item.UserID);
                            gSPacketIn.WriteString(item.NickName);
                            gSPacketIn.WriteInt(item.Rank);
                            gSPacketIn.WriteInt(item.Status);
                            gSPacketIn.WriteInt(item.Winer);
                        }
                        client.Out.SendTCP(gSPacketIn);
                        break;
                    }
            }
            return 0;
        }
    }
}
