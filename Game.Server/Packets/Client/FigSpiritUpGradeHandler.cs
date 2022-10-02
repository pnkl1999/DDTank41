using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Base.Packets;
using Game.Server.GameObjects;
using Bussiness;
using SqlDataProvider.Data;
using Game.Server.GameUtils;
using Bussiness.Managers;

namespace Game.Server.Packets.Client
{
    [PacketHandler((byte)ePackageType.FIGHT_SPIRIT, "场景用户离开")]
    public class FigSpiritUpGradeHandler : IPacketHandler
    {
        private static int[] exps = FightSpiritTemplateMgr.Exps();
        private static int golddenLv = GameProperties.FightSpiritMaxLevel;//FightSpiritTemplateMgr.GOLDEN_LEVEL();        
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
            if (client.Player.PlayerCharacter.Grade < 30)
                return 0;

            int id = client.Player.PlayerCharacter.ID;
            packet.ReadByte();//_loc_2.writeByte(FightSpiritPackageType.FIGHT_SPIRIT_LEVELUP);
            int autoBuyId = packet.ReadInt();//_loc_2.writeInt(param1.autoBuyId);
            int goodsId = packet.ReadInt();//_loc_2.writeInt(param1.goodsId);
            int type = packet.ReadInt();//_loc_2.writeInt(param1.type);
            int templeteId = packet.ReadInt();//_loc_2.writeInt(param1.templeteId);
            int fightSpiritId = packet.ReadInt();//_loc_2.writeInt(param1.fightSpiritId);
            int equipPlace = packet.ReadInt();//_loc_2.writeInt(param1.equipPlayce);
            int place = packet.ReadInt();//_loc_2.writeInt(param1.place);
            int count = packet.ReadInt();//_loc_2.writeInt(param1.count);

            ItemInfo item = client.Player.PropBag.GetItemByTemplateID(0, templeteId);
            int itemCount = client.Player.PropBag.GetItemCount(templeteId);
            UserGemStone gemStone = client.Player.GetGemStone(equipPlace);
            if (gemStone == null)
            {
                client.Player.Out.SendPlayerFigSpiritUp(id, gemStone, false, true, true, 0, 0);
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("FigSpiritUpGradeHandler.Msg"));
                return 0;
            }
            string[] spiritIdValues = gemStone.FigSpiritIdValue.Split('|');

            bool isUp = false;
            bool isMaxLevel = IsMaxLv(spiritIdValues);
            bool isFall = true;
            int num = 1;//exp
            int dir = 0;
            FigSpiritUpInfo[] curFs = new FigSpiritUpInfo[spiritIdValues.Length];
            for (int i = 0; i < spiritIdValues.Length; i++)
            {
                FigSpiritUpInfo info = new FigSpiritUpInfo();
                info.level = Convert.ToInt32(spiritIdValues[i].Split(',')[0]);
                info.exp = Convert.ToInt32(spiritIdValues[i].Split(',')[1]);
                info.place = Convert.ToInt32(spiritIdValues[i].Split(',')[2]);
                curFs[i] = info;
            }
            if (itemCount <= 0 || item == null)
            {
                client.Player.Out.SendPlayerFigSpiritUp(id, gemStone, isUp, isMaxLevel, isFall, 0, dir);
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("FigSpiritUpGradeHandler.Msg"));
                return 0;
            }
            if (!item.isGemStone())
            {
                client.Player.Out.SendPlayerFigSpiritUp(id, gemStone, isUp, isMaxLevel, isFall, 0, dir);
                client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("FigSpiritUpGradeHandler.Msg"));
                return 0;
            }
            if (!isMaxLevel)
            {
                FigSpiritUpInfo curGem = GetCurGem(curFs, place);
                if (curGem == null)
                {
                    client.Player.Out.SendPlayerFigSpiritUp(id, gemStone, isUp, isMaxLevel, isFall, 0, dir);
                    client.Out.SendMessage(eMessageType.Normal, LanguageMgr.GetTranslation("FigSpiritUpGradeHandler.WrongPlace"));
                    return 0;
                }
                int exp = 0;
                switch (autoBuyId)
                {
                    case 1:
                        int needCount = getNeedExp(curGem.exp, curGem.level) / item.Template.Property2;
                        if (itemCount < needCount)
                        {
                            needCount = itemCount;
                        }
                        exp = item.Template.Property2 * needCount;
                        client.Player.PropBag.RemoveTemplate(templeteId, needCount);
                        break;
                    default:
                        exp = item.Template.Property2;
                        client.Player.PropBag.RemoveCountFromStack(item, 1);
                        break;
                }

                if (curGem.level < golddenLv)
                {
                    curGem.exp += exp;
                    isUp = canUpLv(curGem.exp, curGem.level);
                    if (isUp)
                    {
                        curGem.level++;
                        curGem.exp = 0;
                    }
                }
                curFs = UpdateGem(curFs, curGem, isUp);
            }
            else
            {
                client.Player.Out.SendPlayerFigSpiritUp(id, gemStone, isUp, isMaxLevel, isFall, 0, dir);
                return 0;
            }
            if (isUp)
            {
                isFall = false;
                client.Player.EquipBag.UpdatePlayerProperties();
                dir = 1;
            }
            string figSpiritIdValue = curFs[0].level + "," + curFs[0].exp + "," + curFs[0].place;
            for (int i = 1; i < curFs.Length; i++)
            {
                figSpiritIdValue += "|" + curFs[i].level + "," + curFs[i].exp + "," + curFs[i].place;
            }
            gemStone.FigSpiritId = fightSpiritId;
            gemStone.FigSpiritIdValue = figSpiritIdValue;
            client.Player.UpdateGemStone(equipPlace, gemStone);
            client.Player.Out.SendPlayerFigSpiritUp(id, gemStone, isUp, isMaxLevel, isFall, num, dir);
            return 0;
        }

        private int getNeedExp(int _curExp, int _curLv)
        {
            int totalExp = exps[_curLv + 1];
            int currExp = _curExp + exps[_curLv];
            return totalExp - currExp;
        }

        private bool IsMaxLv(string[] SpiritIdValue)
        {
            return SpiritIdValue[0].Split(',')[0] == golddenLv.ToString() && SpiritIdValue[1].Split(',')[0] == golddenLv.ToString() && SpiritIdValue[2].Split(',')[0] == golddenLv.ToString();
        }

        private bool canUpLv(int exp, int curLv)
        {
            for (int i = 1; i < exps.Length; i++)
            {
                if (exp >= exps[i] - exps[i - 1] && curLv == (i - 1))
                    return true;
            }
            return false;
        }

        private FigSpiritUpInfo GetCurGem(FigSpiritUpInfo[] gems, int place)
        {
            foreach (FigSpiritUpInfo fs in gems)
            {
                if (fs.place == place)
                    return fs;
            }
            return null;
        }

        private FigSpiritUpInfo[] UpdateGem(FigSpiritUpInfo[] gems, FigSpiritUpInfo gem, bool isUp)
        {
            for (int i = 0; i < gems.Length; i++)
            {
                if (gems[i].place == gem.place)
                    gems[i] = gem;

            }
            if (isUp)
            {
                IEnumerable<FigSpiritUpInfo> temp = (from p in gems orderby p.level, p.exp ascending select p);
                FigSpiritUpInfo[] lvs = new FigSpiritUpInfo[gems.Length];
                int place = 0;
                foreach (FigSpiritUpInfo fs in temp)
                {
                    switch (place)
                    {
                        case 0:
                            fs.place = 2;
                            break;
                        case 1:
                            fs.place = 1;
                            break;
                        case 2:
                            fs.place = 0;
                            break;
                    }
                    lvs[place] = fs;
                    place++;
                }
                return lvs;
            }
            return gems;
        }
    }
}