using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;
using System.Collections.Generic;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_EQUIP_CONTROL)]
	public class ConsortiaEquipControl : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			if (Player.PlayerCharacter.ConsortiaID == 0)
			{
				return 0;
			}
			bool val = false;
			string msg = "ConsortiaEquipControlHandler.Fail";
			ConsortiaEquipControlInfo consortiaEquipControlInfo = new ConsortiaEquipControlInfo();
			consortiaEquipControlInfo.ConsortiaID = Player.PlayerCharacter.ConsortiaID;
			List<int> list = new List<int>();
			using (ConsortiaBussiness consortiaBussiness = new ConsortiaBussiness())
			{
				for (int i = 0; i < 5; i++)
				{
					consortiaEquipControlInfo.Riches = packet.ReadInt();
					consortiaEquipControlInfo.Type = 1;
					consortiaEquipControlInfo.Level = i + 1;
					consortiaBussiness.AddAndUpdateConsortiaEuqipControl(consortiaEquipControlInfo, Player.PlayerCharacter.ID, ref msg);
					list.Add(consortiaEquipControlInfo.Riches);
				}
				consortiaEquipControlInfo.Riches = packet.ReadInt();
				consortiaEquipControlInfo.Type = 2;
				consortiaEquipControlInfo.Level = 0;
				list.Add(consortiaEquipControlInfo.Riches);
				consortiaBussiness.AddAndUpdateConsortiaEuqipControl(consortiaEquipControlInfo, Player.PlayerCharacter.ID, ref msg);
				consortiaEquipControlInfo.Riches = packet.ReadInt();
				consortiaEquipControlInfo.Type = 3;
				consortiaEquipControlInfo.Level = 0;
				list.Add(consortiaEquipControlInfo.Riches);
				consortiaBussiness.AddAndUpdateConsortiaEuqipControl(consortiaEquipControlInfo, Player.PlayerCharacter.ID, ref msg);
				val = true;
			}
			GSPacketIn gSPacketIn = new GSPacketIn(129);
			gSPacketIn.WriteByte(24);
			gSPacketIn.WriteBoolean(val);
			foreach (int item in list)
			{
				gSPacketIn.WriteInt(item);
			}
			Player.Out.SendTCP(gSPacketIn);
			return 0;
        }
    }
}
