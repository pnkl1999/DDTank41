using Bussiness;
using Bussiness.Managers;
using Bussiness.Protocol;
using Game.Base;
using Game.Base.Packets;
using Game.Logic;
using Game.Server.Managers;
using Game.Server.Packets;
using Game.Server.Rooms;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Net;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Threading;

namespace Game.Server
{
    public class LoginServerConnector : BaseConnector
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        private string m_loginKey;

        private int m_serverId;

        public LoginServerConnector(string ip, int port, int serverid, string name, byte[] readBuffer, byte[] sendBuffer)
            : base(ip, port, autoReconnect: true, readBuffer, sendBuffer)
        {
            m_serverId = serverid;
            m_loginKey = $"{serverid},{name}";
            base.Strict = true;
        }

        protected void AsynProcessPacket(object state)
        {
            try
            {
                GSPacketIn pkg = state as GSPacketIn;
                int code = pkg.Code;
                if (code <= 117)
                {
                    switch (code)
                    {
                        case 0:
                            HandleRSAKey(pkg);
                            break;
                        case 2:
                            HandleKitoffPlayer(pkg);
                            break;
                        case 3:
                            HandleAllowUserLogin(pkg);
                            break;
                        case 4:
                            HandleUserOffline(pkg);
                            break;
                        case 5:
                            HandleUserOnline(pkg);
                            break;
                        case 7:
                            HandleASSState(pkg);
                            break;
                        case 8:
                            HandleConfigState(pkg);
                            break;
                        case 9:
                            HandleChargeMoney(pkg);
                            break;
                        case 10:
                            HandleSystemNotice(pkg);
                            break;
                        case 13:
                            HandleUpdatePlayerMarriedState(pkg);
                            break;
                        case 14:
                            HandleMarryRoomInfoToPlayer(pkg);
                            break;
                        case 15:
                            HandleShutdown(pkg);
                            break;
                        case 19:
                            HandleChatConsortia(pkg);
                            break;
                        case 37:
                            HandleChatPersonal(pkg);
                            break;
                        case 38:
                            HandleSysMess(pkg);
                            break;
                        case 72:
                        case 73:
                            HandleBigBugle(pkg);
                            break;
                        case 117:
                            HandleMailResponse(pkg);
                            break;
                    }
                }
                else if (code <= 160)
                {
                    switch (code)
                    {
                        case 128:
                            HandleConsortiaResponse(pkg);
                            break;
                        case 130:
                            HandleConsortiaCreate(pkg);
                            break;
                        case 158:
                            HandleConsortiaFight(pkg);
                            break;
                        case 160:
                            HandleFriend(pkg);
                            break;
                    }
                }
                else
                {
                    switch (code)
                    {
                        case 177:
                            HandleRate(pkg);
                            return;
                        case 178:
                            HandleMacroDrop(pkg);
                            return;
                        case 179:
                            return;
                        case 180:
                            HandleConsortiaBossInfo(pkg);
                            return;
                        case 904:
                            HandlerEliteGameStatusUpdate(pkg);
                            break;
                        case 906:
                            HandlerEliteGameUpdateRank(pkg);
                            break;
                        case 907:
                            HandleEliteGameRequestStart(pkg);
                            break;
                        case 909:
                            HandlerEliteGameRoundAdd(pkg);
                            break;
                        case 911:
                            HandlerEliteGameSynPlayers(pkg);
                            break;
                        case 912:
                            HandleEliteGameReload(pkg);
                            break;
                        case (int)eChatServerPacket.WORLD_BOSS_UPDATE_BLOOD:
                            HandleWorldBossUpdateBlood(pkg);
                            break;
                        case (int)eChatServerPacket.WORLD_BOSS_START:
                            HandleWorldBossUpdate(pkg);
                            break;
                        case (int)eChatServerPacket.WORLD_BOSS_RANK:
                            HandleWorldBossRank(pkg);
                            break;
                        case (int)eChatServerPacket.WORLD_BOSS_FIGHTOVER:
                            HandleWorldBossFightOver(pkg);
                            break;
                        case (int)eChatServerPacket.WORLD_BOSS_ROOMCLOSE:
                            HandleWorldBossRoomClose(pkg);
                            break;
                        case (int)eChatServerPacket.WORLDBOSS_PRIVATE_INFO:
                            HandleWorldBossPrivateInfo(pkg);
                            break;
                    }
                    if (code == 185)
                    {
                        HandleConsortiaBossSendAward(pkg);
                    }
                }
            }
            catch (Exception exception)
            {
                GameServer.log.Error("AsynProcessPacket", exception);
            }
        }

        protected void HandleAllowUserLogin(object stateInfo)
        {
            try
            {
                GSPacketIn gSPacketIn = (GSPacketIn)stateInfo;
                int num = gSPacketIn.ReadInt();
                if (!gSPacketIn.ReadBoolean())
                {
                    return;
                }
                GamePlayer gamePlayer = LoginMgr.LoginClient(num);
                if (gamePlayer != null)
                {
                    if (gamePlayer.Login())
                    {
                        SendUserOnline(num, gamePlayer.PlayerCharacter.ConsortiaID);
                        WorldMgr.OnPlayerOnline(num, gamePlayer.PlayerCharacter.ConsortiaID);
                    }
                    else
                    {
                        gamePlayer.Client.Disconnect();
                        SendUserOffline(num, 0);
                    }
                }
                else
                {
                    SendUserOffline(num, 0);
                }
            }
            catch (Exception exception)
            {
                GameServer.log.Error("HandleAllowUserLogin", exception);
            }
        }

        public void HandleASSState(GSPacketIn packet)
        {
            bool flag = packet.ReadBoolean();
            AntiAddictionMgr.SetASSState(flag);
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                gamePlayer.Out.SendAASControl(flag, gamePlayer.IsAASInfo, gamePlayer.IsMinor);
            }
        }

        protected void HandleBigBugle(GSPacketIn packet)
        {
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            for (int i = 0; i < allPlayers.Length; i++)
            {
                allPlayers[i].Out.SendTCP(packet);
            }
        }

        public void HandleConfigState(GSPacketIn packet)
        {
            bool flag = packet.ReadBoolean();
            AwardMgr.DailyAwardState = packet.ReadBoolean();
            AntiAddictionMgr.SetASSState(flag);
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                gamePlayer.Out.SendAASControl(flag, gamePlayer.IsAASInfo, gamePlayer.IsMinor);
            }
        }

        public void HandleConsortiaSkillUpGrade(GSPacketIn packet)
        {
            int num = packet.ReadInt();
            string text = packet.ReadString();
            int skillLevel = packet.ReadInt();
            ConsortiaMgr.ConsortiaSkillUpGrade(num, skillLevel);
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ConsortiaID == num)
                {
                    gamePlayer.PlayerCharacter.SkillLevel = skillLevel;
                    gamePlayer.Out.SendTCP(packet);
                }
            }
        }

        public void HandleConsortiaAlly(GSPacketIn packet)
        {
            int num = packet.ReadInt();
            int num2 = packet.ReadInt();
            int state = packet.ReadInt();
            ConsortiaMgr.UpdateConsortiaAlly(num, num2, state);
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ConsortiaID == num || gamePlayer.PlayerCharacter.ConsortiaID == num2)
                {
                    gamePlayer.Out.SendTCP(packet);
                }
            }
        }

        public void HandleConsortiaBanChat(GSPacketIn packet)
        {
            bool isBanChat = packet.ReadBoolean();
            int num = packet.ReadInt();
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ID == num)
                {
                    gamePlayer.PlayerCharacter.IsBanChat = isBanChat;
                    gamePlayer.Out.SendTCP(packet);
                    break;
                }
            }
        }

        public void HandleConsortiaBossClose(ConsortiaInfo consortia)
        {
            SendToAllConsortiaMember(consortia, 1);
        }

        public void HandleConsortiaBossCreateBoss(ConsortiaInfo consortia)
        {
            SendToAllConsortiaMember(consortia, 0);
        }

        public void HandleConsortiaBossDie(ConsortiaInfo consortia)
        {
            SendToAllConsortiaMember(consortia, 2);
        }

        public void HandleConsortiaBossExtendAvailable(ConsortiaInfo consortia)
        {
            SendToAllConsortiaMember(consortia, 3);
        }

        public void HandleConsortiaBossInfo(GSPacketIn pkg)
        {
            ConsortiaInfo consortiaInfo = new ConsortiaInfo
            {
                ConsortiaID = pkg.ReadInt(),
                ChairmanID = pkg.ReadInt(),
                bossState = pkg.ReadByte(),
                endTime = pkg.ReadDateTime(),
                extendAvailableNum = pkg.ReadInt(),
                callBossLevel = pkg.ReadInt(),
                Level = pkg.ReadInt(),
                SmithLevel = pkg.ReadInt(),
                StoreLevel = pkg.ReadInt(),
                SkillLevel = pkg.ReadInt(),
                Riches = pkg.ReadInt(),
                LastOpenBoss = pkg.ReadDateTime(),
                MaxBlood = pkg.ReadLong(),
                TotalAllMemberDame = pkg.ReadLong(),
                IsBossDie = pkg.ReadBoolean(),
                RankList = new Dictionary<string, RankingPersonInfo>()
            };
            int num = pkg.ReadInt();
            for (int i = 0; i < num; i++)
            {
                RankingPersonInfo rankingPersonInfo = new RankingPersonInfo
                {
                    Name = pkg.ReadString(),
                    ID = pkg.ReadInt(),
                    TotalDamage = pkg.ReadInt(),
                    Honor = pkg.ReadInt(),
                    Damage = pkg.ReadInt()
                };
                consortiaInfo.RankList.Add(rankingPersonInfo.Name, rankingPersonInfo);
            }
            switch (pkg.ReadByte())
            {
                case 180:
                    SendToAllConsortiaMember(consortiaInfo, -1);
                    break;
                case 182:
                    HandleConsortiaBossExtendAvailable(consortiaInfo);
                    break;
                case 183:
                    HandleConsortiaBossCreateBoss(consortiaInfo);
                    break;
                case 184:
                    HandleConsortiaBossReload(consortiaInfo);
                    break;
                case 187:
                    HandleConsortiaBossClose(consortiaInfo);
                    break;
                case 188:
                    HandleConsortiaBossDie(consortiaInfo);
                    break;
                case 181:
                case 185:
                case 186:
                    break;
            }
        }

        public void HandleConsortiaBossReload(ConsortiaInfo consortia)
        {
            SendToAllConsortiaMember(consortia, -1);
        }

        public void HandleConsortiaBossSendAward(GSPacketIn pkg)
        {
            int num = pkg.ReadInt();
            for (int i = 0; i < num; i++)
            {
                ConsortiaBossMgr.SendConsortiaAward(pkg.ReadInt());
            }
        }

        public void HandleConsortiaCreate(GSPacketIn packet)
        {
            int consortiaID = packet.ReadInt();
            packet.ReadInt();
            ConsortiaMgr.AddConsortia(consortiaID);
        }

        //public void HandleConsortiaDelete(GSPacketIn packet)
        //{
        //    int num = packet.ReadInt();
        //    GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
        //    GamePlayer[] array = allPlayers;
        //    foreach (GamePlayer gamePlayer in array)
        //    {
        //        if (gamePlayer.PlayerCharacter.ConsortiaID == num)
        //        {
        //            gamePlayer.ClearConsortia(isclear: true);
        //            gamePlayer.AddRobRiches(-gamePlayer.PlayerCharacter.RichesRob);
        //            gamePlayer.Out.SendTCP(packet);
        //        }
        //    }
        //}

        public void HandleConsortiaDelete(GSPacketIn packet)
        {
            int consortiaID = packet.ReadInt();
            GamePlayer[] players = WorldMgr.GetAllPlayers();
            foreach (GamePlayer p in players)
            {
                if (p.PlayerCharacter.ConsortiaID != consortiaID)
                    continue;

                p.ClearConsortia(isclear: true);
                p.AddRobRiches(-p.PlayerCharacter.RichesRob);

                p.Out.SendTCP(packet);
            }

        }

        public void HandleConsortiaDuty(GSPacketIn packet)
        {
            int num = packet.ReadByte();
            int num2 = packet.ReadInt();
            int num3 = packet.ReadInt();
            packet.ReadString();
            int num4 = packet.ReadInt();
            string dutyName = packet.ReadString();
            int right = packet.ReadInt();
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ConsortiaID == num2)
                {
                    if (num == 2 && gamePlayer.PlayerCharacter.DutyLevel == num4)
                    {
                        gamePlayer.PlayerCharacter.DutyName = dutyName;
                    }
                    else if (gamePlayer.PlayerCharacter.ID == num3 && (num == 5 || num == 6 || num == 7 || num == 8 || num == 9))
                    {
                        gamePlayer.PlayerCharacter.DutyLevel = num4;
                        gamePlayer.PlayerCharacter.DutyName = dutyName;
                        gamePlayer.PlayerCharacter.Right = right;
                    }
                    gamePlayer.Out.SendTCP(packet);
                }
            }
        }

        public void HandleConsortiaFight(GSPacketIn packet)
        {
            int num = packet.ReadInt();
            packet.ReadInt();
            string message = packet.ReadString();
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ConsortiaID == num)
                {
                    gamePlayer.Out.SendMessage(eMessageType.ChatNormal, message);
                }
            }
        }

        protected void HandleConsortiaResponse(GSPacketIn packet)
        {
            switch (packet.ReadByte())
            {
                case 1:
                    HandleConsortiaUserPass(packet);
                    break;
                case 2:
                    HandleConsortiaDelete(packet);
                    break;
                case 3:
                    HandleConsortiaUserDelete(packet);
                    break;
                case 4:
                    HandleConsortiaUserInvite(packet);
                    break;
                case 5:
                    HandleConsortiaBanChat(packet);
                    break;
                case 6:
                    HandleConsortiaUpGrade(packet);
                    break;
                case 7:
                    HandleConsortiaAlly(packet);
                    break;
                case 8:
                    HandleConsortiaDuty(packet);
                    break;
                case 9:
                    HandleConsortiaRichesOffer(packet);
                    break;
                case 10:
                    HandleConsortiaShopUpGrade(packet);
                    break;
                case 11:
                    HandleConsortiaSmithUpGrade(packet);
                    break;
                case 12:
                    HandleConsortiaStoreUpGrade(packet);
                    break;
                case 13:
                    HandleConsortiaSkillUpGrade(packet);
                    break;
            }
        }

        public void HandleConsortiaRichesOffer(GSPacketIn packet)
        {
            int num = packet.ReadInt();
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ConsortiaID == num)
                {
                    gamePlayer.Out.SendTCP(packet);
                }
            }
        }

        public void HandleConsortiaShopUpGrade(GSPacketIn packet)
        {
            int num = packet.ReadInt();
            packet.ReadString();
            int shopLevel = packet.ReadInt();
            ConsortiaMgr.ConsortiaShopUpGrade(num, shopLevel);
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ConsortiaID == num)
                {
                    gamePlayer.PlayerCharacter.ShopLevel = shopLevel;
                    gamePlayer.Out.SendTCP(packet);
                }
            }
        }

        public void HandleConsortiaSmithUpGrade(GSPacketIn packet)
        {
            int num = packet.ReadInt();
            packet.ReadString();
            int smithLevel = packet.ReadInt();
            ConsortiaMgr.ConsortiaSmithUpGrade(num, smithLevel);
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ConsortiaID == num)
                {
                    gamePlayer.PlayerCharacter.SmithLevel = smithLevel;
                    gamePlayer.Out.SendTCP(packet);
                }
            }
        }

        public void HandleConsortiaStoreUpGrade(GSPacketIn packet)
        {
            int num = packet.ReadInt();
            packet.ReadString();
            int storeLevel = packet.ReadInt();
            ConsortiaMgr.ConsortiaStoreUpGrade(num, storeLevel);
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ConsortiaID == num)
                {
                    gamePlayer.PlayerCharacter.StoreLevel = storeLevel;
                    gamePlayer.Out.SendTCP(packet);
                }
            }
        }

        public void HandleConsortiaUpGrade(GSPacketIn packet)
        {
            int num = packet.ReadInt();
            packet.ReadString();
            int consortiaLevel = packet.ReadInt();
            ConsortiaMgr.ConsortiaUpGrade(num, consortiaLevel);
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ConsortiaID == num)
                {
                    gamePlayer.PlayerCharacter.ConsortiaLevel = consortiaLevel;
                    gamePlayer.Out.SendTCP(packet);
                }
            }
        }

        public void HandleConsortiaUserDelete(GSPacketIn packet)
        {
            int id = packet.ReadInt();
            int consortiaID = packet.ReadInt();
            GamePlayer[] players = WorldMgr.GetAllPlayers();
            foreach (GamePlayer p in players)
            {
                if (p.PlayerCharacter.ConsortiaID == consortiaID || p.PlayerCharacter.ID == id)
                {
                    if (p.PlayerCharacter.ID == id)
                    {
                        p.ClearConsortia(isclear: true);
                    }
                    p.Out.SendTCP(packet);
                }
            }

        }

        public void HandleConsortiaUserInvite(GSPacketIn packet)
        {
            packet.ReadInt();
            int num = packet.ReadInt();
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ID == num)
                {
                    gamePlayer.Out.SendTCP(packet);
                    break;
                }
            }
        }

        public void HandleConsortiaUserPass(GSPacketIn packet)
        {
            packet.ReadInt();
            packet.ReadBoolean();
            int num = packet.ReadInt();
            string consortiaName = packet.ReadString();
            int num2 = packet.ReadInt();
            packet.ReadString();
            packet.ReadInt();
            packet.ReadString();
            packet.ReadInt();
            string dutyName = packet.ReadString();
            packet.ReadInt();
            packet.ReadInt();
            packet.ReadInt();
            packet.ReadDateTime();
            packet.ReadInt();
            int dutyLevel = packet.ReadInt();
            packet.ReadInt();
            packet.ReadBoolean();
            int right = packet.ReadInt();
            packet.ReadInt();
            packet.ReadInt();
            packet.ReadInt();
            int consortiaRepute = packet.ReadInt();
            packet.ReadString();
            packet.ReadInt();
            packet.ReadInt();
            packet.ReadString();
            packet.ReadInt();
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ID == num2)
                {
                    gamePlayer.BeginChanges();
                    gamePlayer.PlayerCharacter.ConsortiaID = num;
                    gamePlayer.PlayerCharacter.ConsortiaName = consortiaName;
                    gamePlayer.PlayerCharacter.DutyName = dutyName;
                    gamePlayer.PlayerCharacter.DutyLevel = dutyLevel;
                    gamePlayer.PlayerCharacter.Right = right;
                    gamePlayer.PlayerCharacter.ConsortiaRepute = consortiaRepute;
                    ConsortiaInfo consortiaInfo = ConsortiaMgr.FindConsortiaInfo(num);
                    if (consortiaInfo != null)
                    {
                        gamePlayer.PlayerCharacter.ConsortiaLevel = consortiaInfo.Level;
                    }
                    gamePlayer.CommitChanges();
                }
                if (gamePlayer.PlayerCharacter.ConsortiaID == num)
                {
                    gamePlayer.Out.SendTCP(packet);
                }
            }
        }

        public void HandleChargeMoney(GSPacketIn packet)
        {
            WorldMgr.GetPlayerById(packet.ClientID)?.ChargeToUser();
        }

        protected void HandleChatConsortia(GSPacketIn packet)
        {
            packet.ReadByte();
            packet.ReadBoolean();
            packet.ReadString();
            packet.ReadString();
            int num = packet.ReadInt();
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ConsortiaID == num)
                {
                    gamePlayer.Out.SendTCP(packet);
                }
            }
        }

        protected void HandleChatPersonal(GSPacketIn packet)
        {
            int num = packet.ReadInt();
            string text = packet.ReadString();
            string text2 = packet.ReadString();
            string msg = packet.ReadString();
            bool isAutoReply = packet.ReadBoolean();
            int playerID = 0;
            GamePlayer clientByPlayerNickName = WorldMgr.GetClientByPlayerNickName(text);
            GamePlayer clientByPlayerNickName2 = WorldMgr.GetClientByPlayerNickName(text2);
            if (clientByPlayerNickName2 != null)
            {
                playerID = clientByPlayerNickName2.PlayerCharacter.ID;
            }
            if (clientByPlayerNickName != null && !clientByPlayerNickName.IsBlackFriend(playerID))
            {
                num = clientByPlayerNickName.PlayerCharacter.ID;
                clientByPlayerNickName.SendPrivateChat(num, text, text2, msg, isAutoReply);
            }
        }

        public void HandleFirendResponse(GSPacketIn packet)
        {
            WorldMgr.GetPlayerById(packet.ReadInt())?.Out.SendTCP(packet);
        }

        public void HandleFriend(GSPacketIn pkg)
        {
            switch (pkg.ReadByte())
            {
                case 165:
                    HandleFriendState(pkg);
                    break;
                case 166:
                    HandleFirendResponse(pkg);
                    break;
            }
        }

        public void HandleFriendState(GSPacketIn pkg)
        {
            WorldMgr.ChangePlayerState(pkg.ClientID, pkg.ReadInt(), pkg.ReadInt());
        }

        protected void HandleKitoffPlayer(object stateInfo)
        {
            try
            {
                GSPacketIn gSPacketIn = (GSPacketIn)stateInfo;
                int num = gSPacketIn.ReadInt();
                GamePlayer playerById = WorldMgr.GetPlayerById(num);
                if (playerById != null)
                {
                    string msg = gSPacketIn.ReadString();
                    playerById.Out.SendKitoff(msg);
                    playerById.Client.Disconnect();
                }
                else
                {
                    SendUserOffline(num, 0);
                }
            }
            catch (Exception exception)
            {
                GameServer.log.Error("HandleKitoffPlayer", exception);
            }
        }

        public void HandleMacroDrop(GSPacketIn pkg)
        {
            Dictionary<int, MacroDropInfo> dictionary = new Dictionary<int, MacroDropInfo>();
            int num = pkg.ReadInt();
            for (int i = 0; i < num; i++)
            {
                int key = pkg.ReadInt();
                int dropCount = pkg.ReadInt();
                int maxDropCount = pkg.ReadInt();
                MacroDropInfo value = new MacroDropInfo(dropCount, maxDropCount);
                dictionary.Add(key, value);
            }
            MacroDropMgr.UpdateDropInfo(dictionary);
        }

        public void HandleMailResponse(GSPacketIn packet)
        {
            WorldMgr.GetPlayerById(packet.ReadInt())?.Out.SendTCP(packet);
        }

        public void HandleMarryRoomInfoToPlayer(GSPacketIn packet)
        {
            int num = packet.ReadInt();
            GamePlayer playerById = WorldMgr.GetPlayerById(num);
            if (playerById != null)
            {
                packet.Code = 252;
                packet.ClientID = num;
                playerById.Out.SendTCP(packet);
            }
        }

        public void HandleRate(GSPacketIn packet)
        {
            RateMgr.ReLoad();
        }

        public void HandleReload(GSPacketIn packet)
        {
            eReloadType eReloadType = (eReloadType)packet.ReadInt();
            bool result = false;
            switch (eReloadType)
            {
                case eReloadType.ball:
                    result = BallMgr.ReLoad();
                    break;
                case eReloadType.map:
                    result = MapMgr.ReLoadMap();
                    break;
                case eReloadType.mapserver:
                    result = MapMgr.ReLoadMapServer();
                    break;
                case eReloadType.item:
                    result = ItemMgr.ReLoad();
                    break;
                case eReloadType.quest:
                    result = QuestMgr.ReLoad();
                    break;
                case eReloadType.fusion:
                    result = FusionMgr.ReLoad();
                    break;
                case eReloadType.server:
                    GameServer.Instance.Configuration.Refresh();
                    break;
                case eReloadType.rate:
                    result = RateMgr.ReLoad();
                    break;
                case eReloadType.consortia:
                    result = ConsortiaMgr.ReLoad();
                    break;
                case eReloadType.shop:
                    result = ShopMgr.ReLoad();
                    break;
                case eReloadType.fight:
                    result = FightRateMgr.ReLoad();
                    break;
                case eReloadType.dailyaward:
                    result = AwardMgr.ReLoad();
                    break;
                case eReloadType.language:
                    result = LanguageMgr.Reload("");
                    break;
                case eReloadType.petmoeproperty:
                    result = PetMoePropertyMgr.ReLoad();
                    break;
                case eReloadType.accumulactivelogin:
                    result = AccumulActiveLoginMgr.ReLoad();
                    break;
                case eReloadType.newtitle:
                    result = NewTitleMgr.ReLoad();
                    break;
                case eReloadType.fightspirittemplate:
                    result = FightSpiritTemplateMgr.ReLoad();
                    break;
                case eReloadType.active:
                    result = ActiveMgr.ReLoad();
                    if (result)
                    {
                        ActiveMgr.UpdateCurrentServerActive();
                    }
                    break;
                case eReloadType.totem:
                    result = TotemMgr.ReLoad();
                    break;
                case eReloadType.totemhonor:
                    result = TotemHonorMgr.ReLoad();
                    break;
                case eReloadType.fairbattlereward:
                    result = FairBattleRewardMgr.ReLoad();
                    break;
            }
            packet.WriteInt(GameServer.Instance.Configuration.ServerID);
            packet.WriteBoolean(result);
            SendTCP(packet);
        }

        protected void HandleRSAKey(GSPacketIn packet)
        {
            RSAParameters rSAParameters = default(RSAParameters);
            rSAParameters.Modulus = packet.ReadBytes(128);
            rSAParameters.Exponent = packet.ReadBytes();
            RSAParameters parameters = rSAParameters;
            RSACryptoServiceProvider rSACryptoServiceProvider = new RSACryptoServiceProvider();
            rSACryptoServiceProvider.ImportParameters(parameters);
            SendRSALogin(rSACryptoServiceProvider, m_loginKey);
            SendListenIPPort(IPAddress.Parse(GameServer.Instance.Configuration.Ip), GameServer.Instance.Configuration.Port);
        }

        public void HandleShutdown(GSPacketIn pkg)
        {
            GameServer.Instance.Shutdown();
        }

        public void HandleSysMess(GSPacketIn packet)
        {
            if (packet.ReadInt() == 1)
            {
                int playerId = packet.ReadInt();
                string text = packet.ReadString();
                WorldMgr.GetPlayerById(playerId)?.Out.SendMessage(eMessageType.ChatERROR, LanguageMgr.GetTranslation("LoginServerConnector.HandleSysMess.Msg1", text));
            }
        }

        public void HandleSystemNotice(GSPacketIn packet)
        {
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            for (int i = 0; i < allPlayers.Length; i++)
            {
                allPlayers[i].Out.SendTCP(packet);
            }
        }

        public void HandleUpdatePlayerMarriedState(GSPacketIn packet)
        {
            GamePlayer playerById = WorldMgr.GetPlayerById(packet.ReadInt());
            if (playerById != null)
            {
                playerById.LoadMarryProp();
                playerById.LoadMarryMessage();
                playerById.QuestInventory.ClearMarryQuest();
            }
        }

        protected void HandleUserOffline(GSPacketIn packet)
        {
            int num = packet.ReadInt();
            for (int i = 0; i < num; i++)
            {
                int num2 = packet.ReadInt();
                int consortiaID = packet.ReadInt();
                if (LoginMgr.ContainsUser(num2))
                {
                    SendAllowUserLogin(num2);
                }
                WorldMgr.OnPlayerOffline(num2, consortiaID);
            }
        }

        protected void HandleUserOnline(GSPacketIn packet)
        {
            int num = packet.ReadInt();
            for (int i = 0; i < num; i++)
            {
                int num2 = packet.ReadInt();
                int consortiaID = packet.ReadInt();
                LoginMgr.ClearLoginPlayer(num2);
                GamePlayer playerById = WorldMgr.GetPlayerById(num2);
                if (playerById != null)
                {
                    GameServer.log.Error("Player hang in server!!!");
                    playerById.Out.SendKitoff(LanguageMgr.GetTranslation("Game.Server.LoginNext"));
                    playerById.Client.Disconnect();
                }
                WorldMgr.OnPlayerOnline(num2, consortiaID);
            }
        }

        protected override void OnDisconnect()
        {
            base.OnDisconnect();
        }

        public override void OnRecvPacket(GSPacketIn pkg)
        {
            ThreadPool.QueueUserWorkItem(AsynProcessPacket, pkg);
        }

        public void SendAllowUserLogin(int playerid)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(3);
            gSPacketIn.WriteInt(playerid);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaAlly(int consortiaID1, int consortiaID2, int state)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(7);
            gSPacketIn.WriteInt(consortiaID1);
            gSPacketIn.WriteInt(consortiaID2);
            gSPacketIn.WriteInt(state);
            SendTCP(gSPacketIn);
            ConsortiaMgr.UpdateConsortiaAlly(consortiaID1, consortiaID2, state);
        }

        public void SendConsortiaBanChat(int playerid, string playerName, int handleID, string handleName, bool isBan)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(5);
            gSPacketIn.WriteBoolean(isBan);
            gSPacketIn.WriteInt(playerid);
            gSPacketIn.WriteString(playerName);
            gSPacketIn.WriteInt(handleID);
            gSPacketIn.WriteString(handleName);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaCreate(int consortiaID, int offer, string consotiaName)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(130);
            gSPacketIn.WriteInt(consortiaID);
            gSPacketIn.WriteInt(offer);
            gSPacketIn.WriteString(consotiaName);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaDelete(int consortiaID)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(2);
            gSPacketIn.WriteInt(consortiaID);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaDuty(ConsortiaDutyInfo info, int updateType, int consortiaID)
        {
            SendConsortiaDuty(info, updateType, consortiaID, 0, "", 0, "");
        }

        public void SendConsortiaDuty(ConsortiaDutyInfo info, int updateType, int consortiaID, int playerID, string playerName, int handleID, string handleName)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(8);
            gSPacketIn.WriteByte((byte)updateType);
            gSPacketIn.WriteInt(consortiaID);
            gSPacketIn.WriteInt(playerID);
            gSPacketIn.WriteString(playerName);
            gSPacketIn.WriteInt(info.Level);
            gSPacketIn.WriteString(info.DutyName);
            gSPacketIn.WriteInt(info.Right);
            gSPacketIn.WriteInt(handleID);
            gSPacketIn.WriteString(handleName);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaFight(int consortiaID, int riches, string msg)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(158);
            gSPacketIn.WriteInt(consortiaID);
            gSPacketIn.WriteInt(riches);
            gSPacketIn.WriteString(msg);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaInvite(int ID, int playerid, string playerName, int inviteID, string intviteName, string consortiaName, int consortiaID)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(4);
            gSPacketIn.WriteInt(ID);
            gSPacketIn.WriteInt(playerid);
            gSPacketIn.WriteString(playerName);
            gSPacketIn.WriteInt(inviteID);
            gSPacketIn.WriteString(intviteName);
            gSPacketIn.WriteInt(consortiaID);
            gSPacketIn.WriteString(consortiaName);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaKillUpGrade(ConsortiaInfo info)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(13);
            gSPacketIn.WriteInt(info.ConsortiaID);
            gSPacketIn.WriteString(info.ConsortiaName);
            gSPacketIn.WriteInt(info.SkillLevel);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaOffer(int consortiaID, int offer, int riches)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(156);
            gSPacketIn.WriteInt(consortiaID);
            gSPacketIn.WriteInt(offer);
            gSPacketIn.WriteInt(riches);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaRichesOffer(int consortiaID, int playerID, string playerName, int riches)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(9);
            gSPacketIn.WriteInt(consortiaID);
            gSPacketIn.WriteInt(playerID);
            gSPacketIn.WriteString(playerName);
            gSPacketIn.WriteInt(riches);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaShopUpGrade(ConsortiaInfo info)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(10);
            gSPacketIn.WriteInt(info.ConsortiaID);
            gSPacketIn.WriteString(info.ConsortiaName);
            gSPacketIn.WriteInt(info.ShopLevel);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaSmithUpGrade(ConsortiaInfo info)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(11);
            gSPacketIn.WriteInt(info.ConsortiaID);
            gSPacketIn.WriteString(info.ConsortiaName);
            gSPacketIn.WriteInt(info.SmithLevel);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaStoreUpGrade(ConsortiaInfo info)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(12);
            gSPacketIn.WriteInt(info.ConsortiaID);
            gSPacketIn.WriteString(info.ConsortiaName);
            gSPacketIn.WriteInt(info.StoreLevel);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaUpGrade(ConsortiaInfo info)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(6);
            gSPacketIn.WriteInt(info.ConsortiaID);
            gSPacketIn.WriteString(info.ConsortiaName);
            gSPacketIn.WriteInt(info.Level);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaUserDelete(int playerid, int consortiaID, bool isKick, string nickName, string kickName)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128);
            gSPacketIn.WriteByte(3);
            gSPacketIn.WriteInt(playerid);
            gSPacketIn.WriteInt(consortiaID);
            gSPacketIn.WriteBoolean(isKick);
            gSPacketIn.WriteString(nickName);
            gSPacketIn.WriteString(kickName);
            SendTCP(gSPacketIn);
        }

        public void SendConsortiaUserPass(int playerid, string playerName, ConsortiaUserInfo info, bool isInvite, int consortiaRepute)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(128, playerid);
            gSPacketIn.WriteByte(1);
            gSPacketIn.WriteInt(info.ID);
            gSPacketIn.WriteBoolean(isInvite);
            gSPacketIn.WriteInt(info.ConsortiaID);
            gSPacketIn.WriteString(info.ConsortiaName);
            gSPacketIn.WriteInt(info.UserID);
            gSPacketIn.WriteString(info.UserName);
            gSPacketIn.WriteInt(playerid);
            gSPacketIn.WriteString(playerName);
            gSPacketIn.WriteInt(info.DutyID);
            gSPacketIn.WriteString(info.DutyName);
            gSPacketIn.WriteInt(info.Offer);
            gSPacketIn.WriteInt(info.RichesOffer);
            gSPacketIn.WriteInt(info.RichesRob);
            gSPacketIn.WriteDateTime(info.LastDate);
            gSPacketIn.WriteInt(info.Grade);
            gSPacketIn.WriteInt(info.Level);
            gSPacketIn.WriteInt(info.State);
            gSPacketIn.WriteBoolean(info.Sex);
            gSPacketIn.WriteInt(info.Right);
            gSPacketIn.WriteInt(info.Win);
            gSPacketIn.WriteInt(info.Total);
            gSPacketIn.WriteInt(info.Escape);
            gSPacketIn.WriteInt(consortiaRepute);
            gSPacketIn.WriteString(info.LoginName);
            gSPacketIn.WriteInt(info.FightPower);
            gSPacketIn.WriteInt(info.AchievementPoint);
            gSPacketIn.WriteString(info.honor);
            gSPacketIn.WriteInt(info.UseOffer);
            SendTCP(gSPacketIn);
        }

        public void SendListenIPPort(IPAddress ip, int port)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(240);
            gSPacketIn.Write(ip.GetAddressBytes());
            gSPacketIn.WriteInt(port);
            SendTCP(gSPacketIn);
        }

        public void SendMailResponse(int playerid)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(117);
            gSPacketIn.WriteInt(playerid);
            SendTCP(gSPacketIn);
        }

        public void SendMarryRoomDisposeToPlayer(int roomId)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(241);
            gSPacketIn.WriteInt(roomId);
            SendTCP(gSPacketIn);
        }

        public void SendMarryRoomInfoToPlayer(int playerId, bool state, MarryRoomInfo info)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(14);
            gSPacketIn.WriteInt(playerId);
            gSPacketIn.WriteBoolean(state);
            if (state)
            {
                gSPacketIn.WriteInt(info.ID);
                gSPacketIn.WriteString(info.Name);
                gSPacketIn.WriteInt(info.MapIndex);
                gSPacketIn.WriteInt(info.AvailTime);
                gSPacketIn.WriteInt(info.PlayerID);
                gSPacketIn.WriteInt(info.GroomID);
                gSPacketIn.WriteInt(info.BrideID);
                gSPacketIn.WriteDateTime(info.BeginTime);
                gSPacketIn.WriteBoolean(info.IsGunsaluteUsed);
            }
            SendTCP(gSPacketIn);
        }

        public void SendPacket(GSPacketIn packet)
        {
            SendTCP(packet);
        }

        public void SendPingCenter()
        {
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            int val = ((allPlayers != null) ? allPlayers.Length : 0);
            GSPacketIn gSPacketIn = new GSPacketIn(12);
            gSPacketIn.WriteInt(val);
            SendTCP(gSPacketIn);
        }

        public void SendRSALogin(RSACryptoServiceProvider rsa, string key)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(1);
            gSPacketIn.Write(rsa.Encrypt(Encoding.UTF8.GetBytes(key), fOAEP: false));
            SendTCP(gSPacketIn);
        }

        public void SendShutdown(bool isStoping)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(15);
            gSPacketIn.WriteInt(m_serverId);
            gSPacketIn.WriteBoolean(isStoping);
            SendTCP(gSPacketIn);
        }

        public void SendToAllConsortiaMember(ConsortiaInfo consortia, int type)
        {
            if (!ConsortiaBossMgr.AddConsortia(consortia.ConsortiaID, consortia))
            {
                ConsortiaBossMgr.UpdateConsortia(consortia);
            }
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                if (gamePlayer.PlayerCharacter.ConsortiaID == consortia.ConsortiaID)
                {
                    gamePlayer.SendConsortiaBossInfo(consortia);
                    switch (type)
                    {
                        case 0:
                            gamePlayer.SendConsortiaBossOpenClose(0);
                            break;
                        case 1:
                            gamePlayer.SendConsortiaBossOpenClose(1);
                            break;
                        case 2:
                            gamePlayer.SendConsortiaBossOpenClose(2);
                            break;
                        case 3:
                            gamePlayer.SendConsortiaBossOpenClose(3);
                            break;
                    }
                }
            }
        }

        public void SendUpdatePlayerMarriedStates(int playerId)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(13);
            gSPacketIn.WriteInt(playerId);
            SendTCP(gSPacketIn);
        }

        public GSPacketIn SendUserOffline(int playerid, int consortiaID)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(4);
            gSPacketIn.WriteInt(1);
            gSPacketIn.WriteInt(playerid);
            gSPacketIn.WriteInt(consortiaID);
            SendTCP(gSPacketIn);
            return gSPacketIn;
        }

        public GSPacketIn SendUserOnline(Dictionary<int, int> users)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(5);
            gSPacketIn.WriteInt(users.Count);
            foreach (KeyValuePair<int, int> user in users)
            {
                gSPacketIn.WriteInt(user.Key);
                gSPacketIn.WriteInt(user.Value);
            }
            SendTCP(gSPacketIn);
            return gSPacketIn;
        }

        public GSPacketIn SendUserOnline(int playerid, int consortiaID)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(5);
            gSPacketIn.WriteInt(1);
            gSPacketIn.WriteInt(playerid);
            gSPacketIn.WriteInt(consortiaID);
            SendTCP(gSPacketIn);
            return gSPacketIn;
        }

        public void SendEliteChampionBattleStatus(int userId, bool isReady)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(910);
            gSPacketIn.WriteInt(userId);
            gSPacketIn.WriteBoolean(isReady);
            SendTCP(gSPacketIn);
        }

        public void SendEliteScoreUpdate(int playerId, string NickName, int type, int score)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(905);
            gSPacketIn.WriteInt(playerId);
            gSPacketIn.WriteString(NickName);
            gSPacketIn.WriteInt(type);
            gSPacketIn.WriteInt(score);
            SendTCP(gSPacketIn);
        }

        public void SendEliteChampionRoundUpdate(EliteGameRoundInfo round)
        {
            GSPacketIn gSPacketIn = new GSPacketIn(908);
            gSPacketIn.WriteInt(round.RoundID);
            gSPacketIn.WriteInt(round.RoundType);
            gSPacketIn.WriteInt(round.PlayerWin.UserID);
            SendTCP(gSPacketIn);
        }

        public void HandleEliteGameReload(GSPacketIn pkg)
        {
            GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
            GamePlayer[] array = allPlayers;
            foreach (GamePlayer gamePlayer in array)
            {
                gamePlayer.PlayerCharacter.EliteScore = 1000;
                gamePlayer.PlayerCharacter.EliteRank = 0;
            }
            ExerciseMgr.ResetEliteGame();
        }

        public void HandleEliteGameRequestStart(GSPacketIn pkg)
        {
            int num = pkg.ReadInt();
            for (int i = 0; i < num; i++)
            {
                WorldMgr.GetPlayerById(pkg.ReadInt())?.Out.SendEliteGameStartRoom();
            }
        }

        public void HandlerEliteGameSynPlayers(GSPacketIn pkg)
        {
            int num = pkg.ReadInt();
            for (int i = 0; i < num; i++)
            {
                ExerciseMgr.UpdateEliteGameChapionPlayerList(new PlayerEliteGameInfo
                {
                    UserID = pkg.ReadInt(),
                    NickName = pkg.ReadString(),
                    GameType = pkg.ReadInt(),
                    Status = pkg.ReadInt(),
                    Winer = pkg.ReadInt(),
                    Rank = pkg.ReadInt(),
                    CurrentPoint = pkg.ReadInt()
                });
            }
        }

        public void HandlerEliteGameStatusUpdate(GSPacketIn pkg)
        {
            ExerciseMgr.EliteStatus = pkg.ReadInt();
        }

        public void HandlerEliteGameRoundAdd(GSPacketIn pkg)
        {
            ExerciseMgr.AddEliteRound(new EliteGameRoundInfo
            {
                RoundID = pkg.ReadInt(),
                RoundType = pkg.ReadInt(),
                PlayerOne = new PlayerEliteGameInfo
                {
                    UserID = pkg.ReadInt()
                },
                PlayerTwo = new PlayerEliteGameInfo
                {
                    UserID = pkg.ReadInt()
                }
            });
        }

        public void HandlerEliteGameUpdateRank(GSPacketIn pkg)
        {
            pkg.UnCompress();
            int num = pkg.ReadInt();
            for (int i = 0; i < num; i++)
            {
                GamePlayer playerById = WorldMgr.GetPlayerById(pkg.ReadInt());
                if (playerById != null)
                {
                    playerById.PlayerCharacter.EliteRank = pkg.ReadInt();
                }
                else
                {
                    pkg.ReadInt();
                }
            }
        }

        public GSPacketIn SendLuckStarRewardRecord(int PlayerID, string nickName, int TemplateID, int Count, int isVip)
        {
            GSPacketIn pkg = new GSPacketIn((byte)eChatServerPacket.EVENT_RANKING);
            pkg.WriteByte((byte)eEventPacket.LUCKSTAR_REWARD_RECORD);
            pkg.WriteInt(PlayerID);
            pkg.WriteString(nickName);
            pkg.WriteInt(TemplateID);
            pkg.WriteInt(Count);
            pkg.WriteInt(isVip);
            SendTCP(pkg);
            return pkg;
        }

        #region WorldBoss
        public void HandleWorldBossUpdate(GSPacketIn pkg)
        {
            RoomMgr.WorldBossRoom.UpdateWorldBoss(pkg);
        }

        public void HandleWorldBossUpdateBlood(GSPacketIn pkg)
        {
            RoomMgr.WorldBossRoom.SendUpdateBlood(pkg);
        }

        public void HandleWorldBossRank(GSPacketIn pkg)
        {
            RoomMgr.WorldBossRoom.UpdateWorldBossRankCrosszone(pkg);
        }

        public void HandleWorldBossPrivateInfo(GSPacketIn pkg)
        {
            string name = pkg.ReadString();
            int damage = pkg.ReadInt();
            int honor = pkg.ReadInt();
            RoomMgr.WorldBossRoom.SendPrivateInfo(name, damage, honor);
        }

        public void HandleWorldBossFightOver(GSPacketIn pkg)
        {
            RoomMgr.WorldBossRoom.SendFightOver();
        }

        public void HandleWorldBossRoomClose(GSPacketIn pkg)
        {
            if (pkg.ReadByte() == 0)
            {
                RoomMgr.WorldBossRoom.SendRoomClose();
            }
            else
            {
                RoomMgr.WorldBossRoom.WorldBossClose();
            }
        }
        #endregion
    }
}
