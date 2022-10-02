using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Game.Server.Packets;
using Game.Server.GameObjects;
using Game.Server.Packets.Client;
using Game.Base.Packets;
using Game.Server.Buffer;
using SqlDataProvider.Data;
using Bussiness;
using Game.Server.Managers;
using Bussiness.Managers;

namespace Game.Server.Consortia.Handle
{
    [ConsortiaHandleAttbute((byte)ConsortiaPackageType.CONSORTIA_LEVEL_UP)]
    public class ConsortiaLevelUp : IConsortiaCommandHadler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            if (Player.PlayerCharacter.ConsortiaID == 0)
                return 0;
            byte type = packet.ReadByte();
            string msg = "";
            string notice = "";
            byte level = 0;
            bool result = false;
            ConsortiaInfo info = ConsortiaMgr.FindConsortiaInfo(Player.PlayerCharacter.ConsortiaID);
            switch (type)
            {
                case 1:
                    msg = "ConsortiaUpGradeHandler.Failed";
                    using (ConsortiaBussiness db = new ConsortiaBussiness())
                    {
                        ConsortiaInfo consortia = db.GetConsortiaSingle(Player.PlayerCharacter.ConsortiaID);
                        if (consortia == null)
                        {
                            msg = "ConsortiaUpGradeHandler.NoConsortia";
                        }
                        else
                        {
                            ConsortiaLevelInfo levelInfo = ConsortiaExtraMgr.FindConsortiaLevelInfo(consortia.Level + 1);

                            if (levelInfo == null)
                            {
                                msg = "ConsortiaUpGradeHandler.NoUpGrade";
                            }

                            else if (levelInfo.NeedGold > Player.PlayerCharacter.Gold)
                            {
                                msg = "ConsortiaUpGradeHandler.NoGold";
                            }
                            else
                            {
                                using (ConsortiaBussiness cb = new ConsortiaBussiness())
                                {
                                    if (cb.UpGradeConsortia(Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, ref msg))
                                    {
                                        consortia.Level++;
                                        Player.RemoveGold(levelInfo.NeedGold);
                                        GameServer.Instance.LoginServer.SendConsortiaUpGrade(consortia);
                                        msg = "ConsortiaUpGradeHandler.Success";
                                        result = true;
                                        level = (byte)consortia.Level;
                                    }
                                }
                            }
                        }

                        if (consortia.Level >= 5)
                        {
                            notice = LanguageMgr.GetTranslation("ConsortiaUpGradeHandler.Notice", consortia.ConsortiaName, consortia.Level);
                        }
                    }
                    break;

                case 2://StoreLevel
                    msg = "ConsortiaStoreUpGradeHandler.Failed";
                    if (info == null)
                    {
                        msg = "ConsortiaStoreUpGradeHandler.NoConsortia";
                    }
                    else
                    {
                        using (ConsortiaBussiness cb = new ConsortiaBussiness())
                        {
                            if (cb.UpGradeStoreConsortia(Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, ref msg))
                            {
                                info.StoreLevel++;
                                GameServer.Instance.LoginServer.SendConsortiaStoreUpGrade(info);
                                msg = "ConsortiaStoreUpGradeHandler.Success";
                                result = true;
                                level = (byte)info.StoreLevel;
                            }
                        }
                    }
                    break;

                case 3://ShopLevel
                    msg = "ConsortiaShopUpGradeHandler.Failed";
                    if (info == null)
                    {
                        msg = "ConsortiaShopUpGradeHandler.NoConsortia";
                    }
                    else
                    {
                        using (ConsortiaBussiness cb = new ConsortiaBussiness())
                        {
                            if (cb.UpGradeShopConsortia(Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, ref msg))
                            {
                                info.ShopLevel++;
                                GameServer.Instance.LoginServer.SendConsortiaShopUpGrade(info);
                                msg = "ConsortiaShopUpGradeHandler.Success";
                                result = true;
                                level = (byte)info.ShopLevel;
                            }
                        }
                    }

                    if (info.ShopLevel >= 2)
                    {
                        notice = LanguageMgr.GetTranslation("ConsortiaShopUpGradeHandler.Notice", Player.PlayerCharacter.ConsortiaName, info.ShopLevel);
                    }
                    break;
                case 4://SmithLevel
                    msg = "ConsortiaSmithUpGradeHandler.Failed";
                    if (info == null)
                    {
                        msg = "ConsortiaSmithUpGradeHandler.NoConsortia";
                    }
                    else
                    {
                        using (ConsortiaBussiness cb = new ConsortiaBussiness())
                        {
                            if (cb.UpGradeSmithConsortia(Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, ref msg))
                            {
                                info.SmithLevel++;
                                GameServer.Instance.LoginServer.SendConsortiaSmithUpGrade(info);
                                msg = "ConsortiaSmithUpGradeHandler.Success";
                                result = true;
                                level = (byte)info.SmithLevel;
                            }
                        }
                    }

                    if (info.SmithLevel >= 3)
                    {
                        notice = LanguageMgr.GetTranslation("ConsortiaSmithUpGradeHandler.Notice", Player.PlayerCharacter.ConsortiaName, info.SmithLevel);
                    }
                    break;
                case 5://BufferLevel
                    msg = "ConsortiaBufferUpGradeHandler.Failed";
                    if (info == null)
                    {
                        msg = "ConsortiaUpGradeHandler.NoConsortia";
                    }
                    else
                    {
                        using (ConsortiaBussiness cb = new ConsortiaBussiness())
                        {
                            if (cb.UpGradeSkillConsortia(Player.PlayerCharacter.ConsortiaID, Player.PlayerCharacter.ID, ref msg))
                            {
                                info.SkillLevel++;
                                GameServer.Instance.LoginServer.SendConsortiaKillUpGrade(info);
                                msg = "ConsortiaBufferUpGradeHandler.Success";
                                result = true;
                                level = (byte)info.SkillLevel;
                            }
                        }
                    }

                    if (info.SkillLevel >= 3)
                    {
                        notice = LanguageMgr.GetTranslation("ConsortiaBufferUpGradeHandler.Notice", Player.PlayerCharacter.ConsortiaName, info.SmithLevel);
                    }
                    break;
            }
            GSPacketIn pkg = new GSPacketIn((byte)ePackageType.CONSORTIA_CMD);
            pkg.WriteByte((byte)ConsortiaPackageType.CONSORTIA_LEVEL_UP);
            pkg.WriteByte(type);
            pkg.WriteByte(level);
            pkg.WriteBoolean(result);
            pkg.WriteString(LanguageMgr.GetTranslation(msg));
            Player.Out.SendTCP(pkg);

            if (notice != "")
            {
                GSPacketIn pkgNotice = new GSPacketIn((byte)ePackageType.SYS_NOTICE);
                pkgNotice.WriteInt(2);
                pkgNotice.WriteString(notice);
                GameServer.Instance.LoginServer.SendPacket(pkgNotice);
                GamePlayer[] gps = WorldMgr.GetAllPlayers();
                foreach (GamePlayer p in gps)
                {
                    if (p != Player)
                        p.Out.SendTCP(pkgNotice);
                }
            }
            return 0;
        }
    }
}
