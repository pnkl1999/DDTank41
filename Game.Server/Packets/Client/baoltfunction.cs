using Bussiness;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Managers;
using System;
using Game.Server.GameUtils;
using SqlDataProvider.Data;
using Bussiness.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler(300, "baolt function")]
    public class baoltfunction : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int code = packet.ReadInt();
            int code2 = code;
            switch (code2)
            {
                case 0:
                    this.CheckSpeedHack(client);
                    break;
                default:
                    break;
            }
            return 0;
        }

        public void CheckSpeedHack(GameClient client)
        {
            long minuspercheck = 5; // so phuts check 1 lan tren flash
            long thetimebefore = client.Player.TimeCheckHack;
            long thetimenow = (long)(DateTime.UtcNow.Subtract(new DateTime(1970, 1, 1))).TotalSeconds;
            if ((thetimenow - thetimebefore) < (minuspercheck * 60 - 15))
            {
                Console.WriteLine("Hack Speed detect: " + client.Player.PlayerCharacter.UserName);
                client.Player.SendMessage("Bạn bị tạm khoá 20 phút do sử dụng cỗ máy thời gian!");
                WorldMgr.SendSysNotice("[Hệ thống] [" + client.Player.ZoneName + "] Phát hiện người chơi [" + client.Player.PlayerCharacter.NickName + "] sử dụng cỗ máy thời gian, tài khoản bị giam ở TVA 20 phút.");
                client.Player.AddLog("Speed", "Bug speed with cheat");
                client.Player.SaveIntoDatabase();
                client.Player.SavePlayerInfo();
                using (ManageBussiness mnbusiness = new ManageBussiness())
                {
                    mnbusiness.ForbidPlayerByUserID(client.Player.PlayerCharacter.ID, DateTime.Now.AddMinutes(20.0), true, "Hack speed");
                }
                client.Disconnect();
            }
            else
            {
                client.Player.TimeCheckHack = thetimenow;
                GSPacketIn pkg = new GSPacketIn(300);
                pkg.WriteInt(0);
                client.Out.SendTCP(pkg);
            }
        }

    }
}
