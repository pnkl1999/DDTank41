using Bussiness;
using Game.Base.Packets;

namespace Game.Server.Farm.Handle
{
    [FarmHandleAttbute(4)]
	public class GainFields : IFarmCommandHadler
    {
        public bool CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			int fieldId = packet.ReadInt();
			string msg = LanguageMgr.GetTranslation("Thu hoạch thất bại!");
			if (num == Player.PlayerCharacter.ID && Player.Farm.GainField(fieldId))
			{
				msg = LanguageMgr.GetTranslation("Thu hoạch thành công!");
			}
			else if (num != Player.PlayerCharacter.ID)
			{
				msg = ((!Player.Farm.GainFriendFields(num, fieldId)) ? LanguageMgr.GetTranslation("Không thể chộm nữa.") : LanguageMgr.GetTranslation("Thao tác thành công."));
			}
			Player.SendMessage(msg);
			return true;
        }
    }
}
