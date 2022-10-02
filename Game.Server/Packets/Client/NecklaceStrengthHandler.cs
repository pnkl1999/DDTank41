using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Bussiness;
using SqlDataProvider.Data;
using Game.Server.GameUtils;
using Game.Server.Managers;
using Game.Server.Statics;
using Game.Server.GameObjects;
using Bussiness.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler((int)ePackageType.NECKLACE_STRENGTH, "客户端日记")]
    public class NecklaceStrengthHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            int type = packet.ReadByte();//_loc_4.writeByte(param3);
            int stonePlace = packet.ReadInt();//_loc_4.writeInt(param2);
            int count = packet.ReadInt();//_loc_4.writeInt(param1);
            //Console.WriteLine(string.Format("stonePlace {0} count {1} param3 {2}", stonePlace, count, type));
            ItemInfo stone = client.Player.PropBag.GetItemAt(stonePlace);
            if (stone == null)
                return 0;
            if (stone.Count < count)
                count = stone.Count;
            switch (type)
            {
                case 1:
                    {

                    }
                    break;
                case 2:
                    {
                        int MAX_LEVEL = StrengthenMgr.NECKLACE_MAX_LEVEL;
                        int stoneExp = stone.Template.Property2;
                        int currentLv = StrengthenMgr.GetNecklaceLevelByGP(client.Player.PlayerCharacter.necklaceExp);
                        int currentExpAdd = client.Player.PlayerCharacter.necklaceExpAdd;
                        if (currentLv < MAX_LEVEL && stone != null && stone.TemplateID == (int)EquipType.NECKLACE_PTETROCHEM_STONE && count > 0)
                        {
                            int totalExp = client.Player.PlayerCharacter.necklaceExp + stoneExp * count;
                            int maxExp = StrengthenMgr.GetNecklaceMaxExp();
                            if (maxExp == 0)
                            {
                                return 0;
                            }

                            if (totalExp > maxExp)
                            {
                                int needExp = maxExp - client.Player.PlayerCharacter.necklaceExp;
                                totalExp = client.Player.PlayerCharacter.necklaceExp + needExp;
                                count = (needExp / stoneExp) <= 0 ? 1 : (needExp / stoneExp);
                            }
                            client.Player.PlayerCharacter.necklaceExp = totalExp;
                            int nextExpAdd = StrengthenMgr.GetNecklaceExpAdd(client.Player.PlayerCharacter.necklaceExp, currentExpAdd);
                            if (currentExpAdd < nextExpAdd)
                                client.Player.EquipBag.UpdatePlayerProperties();

                            client.Player.PlayerCharacter.necklaceExpAdd = nextExpAdd;
                            client.Player.RemoveTemplate(stone.TemplateID, count);
                            //Console.WriteLine(string.Format("necklaceExp {0} necklaceExpAdd {1} num {2}", client.Player.PlayerCharacter.necklaceExp, client.Player.PlayerCharacter.necklaceExpAdd, count));

                        }
                    }
                    break;
            }
            client.Player.Out.SendNecklaceStrength(client.Player.PlayerCharacter);
            return 0;
        }

    }
}
