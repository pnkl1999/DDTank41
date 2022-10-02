using Bussiness;
using Game.Base.Packets;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Consortia.Handle
{
	[ConsortiaHandleAttbute((byte)ConsortiaPackageType.DONATE)]
	public class Donate : IConsortiaCommandHadler
	{
		public int CommandHandler(GamePlayer Player, GSPacketIn packet)
		{
			if (Player.PlayerCharacter.ConsortiaID == 0)
			{
				return 0;
			}

			int itemType = packet.ReadInt();
			int amount = packet.ReadInt();
			switch (itemType)
			{
				//case 11408:
				//	if (Player.GetMedalNum() >= amount)
				//	{
				//		Player.RemoveMedal(amount);
				//	} else
    //                {
				//		Player.SendMessage("Không đủ huân chương!");
    //                }
				//	break;
				default:
					Console.WriteLine("Undefined itemType donation Consortia : {0}", itemType);
					break;
            }
			return 0;
		}
	}
}
