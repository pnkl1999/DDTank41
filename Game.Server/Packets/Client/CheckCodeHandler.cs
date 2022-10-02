using Bussiness;
using Game.Base.Packets;
using Game.Server.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler(200, "验证码")]
    public class CheckCodeHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            bool result = false;
            if (string.IsNullOrEmpty(client.Player.PlayerCharacter.CheckCode))
                return 1;

            //int check  = packet.ReadInt();

            string check = packet.ReadString();
            if (check == "cheat")
            {
                client.Player.PlayerCharacter.CheckCount += 1;
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("CheckCodeHandler.Msg3"));
                client.Disconnect();
            }
            else if (client.Player.PlayerCharacter.CheckCode.ToLower() == check.ToLower())
            {
                client.Player.PlayerCharacter.CheckCount = 0;
                client.Player.PlayerCharacter.CheckCode = "baodeptrai";
                client.Player.resetPassCode();
                client.Out.SendMessage(eMessageType.Normal, "Xác thực thành công, chúc bạn chơi game vui vẻ.");

                packet.ClearContext();
                packet.WriteByte(1);
                packet.WriteBoolean(false);
                client.Out.SendTCP(packet);
            }
            else if (client.Player.PlayerCharacter.CheckError < 9)
            {
                client.Player.PlayerCharacter.CheckCount += 1;
                client.Out.SendMessage(eMessageType.ChatERROR, "Xác thực sai, nếu sai nhiều lần bạn có thể bị đá ra khỏi game.");
                client.Player.PlayerCharacter.CheckError++;
                client.Player.ShowCheckCode();
            }
            else
            {
                client.Player.PlayerCharacter.CheckCount += 1;
                client.Out.SendMessage(eMessageType.Normal, "Xác thực sai quá nhiều lần, bye bye !.");
                client.Disconnect();
            }
            return 0;
        }
    }
}
