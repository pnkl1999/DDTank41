using Bussiness;
using Game.Base.Packets;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_BANCHAT_UPDATE)]
	public class ConsortiaIsBanChat : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.PlayerCharacter.ConsortiaID == 0)
			{
				return 0;
			}
			int num = packet.ReadInt();
			bool flag = packet.ReadBoolean();
			int tempID = 0;
			string tempName = "";
			bool val = false;
			string msg = "ConsortiaIsBanChatHandler.Failed";
			using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
			{
				if (consortiaBussiness.UpdateConsortiaIsBanChat(num, Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, flag, ref tempID, ref tempName, ref msg))
				{
					msg = "ConsortiaIsBanChatHandler.Success";
					val = true;
					GameServer.Instance.LoginServer.SendConsortiaBanChat(tempID, tempName, Player.PlayerCharacter.ID, Player.PlayerCharacter.NickName, flag);
				}
			}
			GSPacketIn gSPacketIn = new GSPacketIn(129);
			gSPacketIn.WriteByte(16);
			gSPacketIn.WriteInt(num);
			gSPacketIn.WriteBoolean(flag);
			gSPacketIn.WriteBoolean(val);
			gSPacketIn.WriteString(LanguageMgr.GetTranslation(msg));
			Player.Out.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
