using Bussiness;
using Game.Base.Packets;
using Game.Server.Packets;
using System.Text;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_USER_REMARK_UPDATE)]
	public class ConsortiaUserRemark : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.PlayerCharacter.ConsortiaID == 0)
			{
				return 0;
			}
			int num = packet.ReadInt();
			string text = packet.ReadString();
			if (!string.IsNullOrEmpty(text) && Encoding.Default.GetByteCount(text) <= 100)
			{
				bool val = false;
				string msg = "ConsortiaUserRemarkHandler.Failed";
				using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
				{
					if (consortiaBussiness.UpdateConsortiaUserRemark(num, Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, text, ref msg))
					{
						msg = "ConsortiaUserRemarkHandler.Success";
						val = true;
					}
				}
				GSPacketIn gSPacketIn = new GSPacketIn(129);
				gSPacketIn.WriteByte(17);
				gSPacketIn.WriteInt(num);
				gSPacketIn.WriteString(text);
				gSPacketIn.WriteBoolean(val);
				gSPacketIn.WriteString(LanguageMgr.GetTranslation(msg));
				Player.Out.SendTCP(gSPacketIn);
				return 0;
			}
			Player.Out.SendMessage(eMessageType.GM_NOTICE, LanguageMgr.GetTranslation("ConsortiaUserRemarkHandler.Long"));
			return 1;
        }
    }
}
