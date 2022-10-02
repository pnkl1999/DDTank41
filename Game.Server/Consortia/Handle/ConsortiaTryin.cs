using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_TRYIN)]
	public class ConsortiaTryin : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.PlayerCharacter.ConsortiaID != 0)
			{
				return 0;
			}
			int num = packet.ReadInt();
			bool val = false;
			string msg = "ConsortiaApplyLoginHandler.ADD_Failed";
			using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
			{
				if (consortiaBussiness.AddConsortiaApplyUsers(new ConsortiaApplyUserInfo
				{
					ApplyDate = DateTime.Now,
					ConsortiaID = num,
					ConsortiaName = "",
					IsExist = true,
					Remark = "",
					UserID = Player.PlayerCharacter.ID,
					UserName = Player.PlayerCharacter.NickName
				}, ref msg))
				{
					msg = ((num != 0) ? "ConsortiaApplyLoginHandler.ADD_Success" : "ConsortiaApplyLoginHandler.DELETE_Success");
					val = true;
				}
			}
			GSPacketIn gSPacketIn = new GSPacketIn(129);
			gSPacketIn.WriteByte(0);
			gSPacketIn.WriteInt(num);
			gSPacketIn.WriteBoolean(val);
			gSPacketIn.WriteString(LanguageMgr.GetTranslation(msg));
			Player.Out.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
