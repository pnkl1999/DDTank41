using Bussiness;
using Bussiness.Managers;
using Fighting.Server.GameObjects;
using Fighting.Server.Games;
using Fighting.Server.Rooms;
using Game.Base;
using Game.Base.Packets;
using Game.Logic;
using Game.Logic.Phy.Object;
using Game.Logic.Protocol;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;

namespace Fighting.Server
{
    public class ServerClient : BaseClient
    {
        private static readonly ILog ilog_1;

        private RSACryptoServiceProvider rsacryptoServiceProvider_0;

        private FightServer m_svr;

        private Dictionary<int, ProxyRoom> m_rooms = new Dictionary<int, ProxyRoom>();

        protected override void OnConnect()
        {
			base.OnConnect();
			rsacryptoServiceProvider_0 = new RSACryptoServiceProvider();
			RSAParameters rsaParameters = rsacryptoServiceProvider_0.ExportParameters(includePrivateParameters: false);
			SendRSAKey(rsaParameters.Modulus, rsaParameters.Exponent);
        }

        protected override void OnDisconnect()
        {
			base.OnDisconnect();
			rsacryptoServiceProvider_0 = null;
        }

        public override void OnRecvPacket(GSPacketIn pkg)
        {
			int code = pkg.Code;
			switch (code)
			{
			case 1:
				HandleLogin(pkg);
				break;
			case 2:
				HanleSendToGame(pkg);
				break;
			case 3:
				HandleSysNotice(pkg);
				break;
			case 19:
				HandlePlayerMessage(pkg);
				break;
			case 36:
				HandlePlayerUsingProp(pkg);
				break;
			case 64:
				HandleGameRoomCreate(pkg);
				break;
			case 65:
				HandleGameRoomCancel(pkg);
				break;
			case 77:
				HandleConsortiaAlly(pkg);
				break;
			case 83:
				HandlePlayerExit(pkg);
				break;
			default:
			{
				eFightPackageType eFightPackageType = (eFightPackageType)code;
				Console.WriteLine("??????????ServerClient: " + eFightPackageType);
				break;
			}
			}
        }

        private void HandlePlayerExit(GSPacketIn pkg)
        {
			BaseGame game = GameMgr.FindGame(pkg.ClientID);
			if (game == null)
			{
				return;
			}
			Player player = game.FindPlayer(pkg.Parameter1);
			if (player != null)
			{
				GSPacketIn pkg2 = new GSPacketIn(83, player.PlayerDetail.PlayerCharacter.ID);
				game.SendToAll(pkg2);
				game.RemovePlayer(player.PlayerDetail, IsKick: false);
				ProxyRoom room1 = ProxyRoomMgr.GetRoomUnsafe((game as BattleGame).Red.RoomId);
				if (room1 != null && !room1.RemovePlayer(player.PlayerDetail))
				{
					ProxyRoomMgr.GetRoomUnsafe((game as BattleGame).Blue.RoomId)?.RemovePlayer(player.PlayerDetail);
				}
			}
        }

        private void HandlePlayerUsingProp(GSPacketIn pkg)
        {
			BaseGame game = GameMgr.FindGame(pkg.ClientID);
			if (game == null)
			{
				return;
			}
			game.Resume();
			if (pkg.ReadBoolean())
			{
				Player player = game.FindPlayer(pkg.Parameter1);
				ItemTemplateInfo template = ItemMgr.FindItemTemplate(pkg.Parameter2);
				if (player != null && template != null)
				{
					player.UseItem(template);
				}
			}
        }

        private void HandleSysNotice(GSPacketIn pkg)
        {
			BaseGame game = GameMgr.FindGame(pkg.ClientID);
			if (game != null)
			{
				Player player = game.FindPlayer(pkg.Parameter1);
				GSPacketIn pkg2 = new GSPacketIn(3);
				pkg2.WriteInt(3);
				pkg2.WriteString(LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg6", player.PlayerDetail.PlayerCharacter.Grade * 12, 15));
				player.PlayerDetail.SendTCP(pkg2);
				pkg2.ClearContext();
				pkg2.WriteInt(3);
				pkg2.WriteString(LanguageMgr.GetTranslation("AbstractPacketLib.SendGamePlayerLeave.Msg7", player.PlayerDetail.PlayerCharacter.NickName, player.PlayerDetail.PlayerCharacter.Grade * 12, 15));
				game.SendToAll(pkg2, player.PlayerDetail);
			}
        }

        private void HandlePlayerMessage(GSPacketIn pkg)
        {
			BaseGame game = GameMgr.FindGame(pkg.ClientID);
			if (game == null)
			{
				return;
			}
			Player player = game.FindPlayer(pkg.ReadInt());
			bool team = pkg.ReadBoolean();
			string msg = pkg.ReadString();
			if (player != null)
			{
				GSPacketIn pkg2 = new GSPacketIn(19);
				pkg2.ClientID = player.PlayerDetail.PlayerCharacter.ID;
				pkg2.WriteInt(player.PlayerDetail.ZoneId);
				pkg2.WriteByte(5);
				pkg2.WriteBoolean(team);
				pkg2.WriteString(player.PlayerDetail.PlayerCharacter.NickName);
				pkg2.WriteString(msg);
				if (team)
				{
					game.SendToTeam(pkg, player.Team);
				}
				else
				{
					game.SendToAll(pkg2);
				}
			}
        }

        public void HandleConsortiaAlly(GSPacketIn pkg)
        {
			BaseGame game = GameMgr.FindGame(pkg.ClientID);
			if (game != null)
			{
				game.ConsortiaAlly = pkg.ReadInt();
				game.RichesRate = pkg.ReadInt();
			}
        }

        public void HandleLogin(GSPacketIn pkg)
        {
			string[] strArray = Encoding.UTF8.GetString(rsacryptoServiceProvider_0.Decrypt(pkg.ReadBytes(), fOAEP: false)).Split(',');
			if (strArray.Length == 2)
			{
				rsacryptoServiceProvider_0 = null;
				int.Parse(strArray[0]);
				base.Strict = false;
			}
			else
			{
				ilog_1.ErrorFormat("Error Login Packet from {0}", base.TcpEndpoint);
				Disconnect();
			}
        }

        public void HandleGameRoomCreate(GSPacketIn pkg)
        {
			int num1 = pkg.ReadInt();
			int num18 = pkg.ReadInt();
			int num19 = pkg.ReadInt();
			int num20 = pkg.ReadInt();
			int npcId = pkg.ReadInt();
			bool pickUpWithNPC = pkg.ReadBoolean();
			bool isBot = pkg.ReadBoolean();
			bool flag = pkg.ReadBoolean();
			int length = pkg.ReadInt();
			int num21 = 0;
			int num22 = 0;
			int zoneID = 0;
			int num2 = 0;
			int maxLevel = 0;
			IGamePlayer[] players = new IGamePlayer[length];
			for (int index1 = 0; index1 < length; index1++)
			{
				PlayerInfo character = new PlayerInfo();
				ProxyPlayerInfo proxyPlayer = new ProxyPlayerInfo();
				character.ID = pkg.ReadInt();
				character.UserName = pkg.ReadString();
				bool isViewer = pkg.ReadBoolean();
				int num24 = (proxyPlayer.ZoneId = pkg.ReadInt());
				int num15 = num24;
				zoneID = num15;
				proxyPlayer.ZoneName = pkg.ReadString();
				int num3 = pkg.ReadInt();
				character.NickName = pkg.ReadString();
				character.Sex = pkg.ReadBoolean();
				character.Hide = pkg.ReadInt();
				character.Style = pkg.ReadString();
				character.Colors = pkg.ReadString();
				character.Skin = pkg.ReadString();
				character.Offer = pkg.ReadInt();
				character.GP = pkg.ReadInt();
				character.Grade = pkg.ReadInt();
				character.Repute = pkg.ReadInt();
				character.ConsortiaID = pkg.ReadInt();
				character.ConsortiaName = pkg.ReadString();
				character.ConsortiaLevel = pkg.ReadInt();
				character.ConsortiaRepute = pkg.ReadInt();
				character.IsShowConsortia = pkg.ReadBoolean();
				character.badgeID = pkg.ReadInt();
				character.Honor = pkg.ReadString();
				character.AchievementPoint = pkg.ReadInt();
				character.WeaklessGuildProgressStr = pkg.ReadString();
				character.MoneyPlus = pkg.ReadInt();
				character.FightPower = pkg.ReadInt();
				character.Nimbus = pkg.ReadInt();
				character.apprenticeshipState = pkg.ReadInt();
				character.masterID = pkg.ReadInt();
				character.masterOrApprentices = pkg.ReadString();
				character.IsAutoBot = isBot;
				num2 += character.FightPower;
				character.Attack = pkg.ReadInt();
				character.Defence = pkg.ReadInt();
				character.Agility = pkg.ReadInt();
				character.Luck = pkg.ReadInt();
				character.hp = pkg.ReadInt();
				proxyPlayer.BaseAttack = pkg.ReadDouble();
				proxyPlayer.BaseDefence = pkg.ReadDouble();
				proxyPlayer.BaseAgility = pkg.ReadDouble();
				proxyPlayer.BaseBlood = pkg.ReadDouble();
				proxyPlayer.TemplateId = pkg.ReadInt();
				proxyPlayer.WeaponStrengthLevel = pkg.ReadInt();
				int num5 = pkg.ReadInt();
				if (num5 != 0)
				{
					proxyPlayer.GoldTemplateId = num5;
					proxyPlayer.goldBeginTime = pkg.ReadDateTime();
					proxyPlayer.goldValidDate = pkg.ReadInt();
				}
				proxyPlayer.CanUserProp = pkg.ReadBoolean();
				proxyPlayer.SecondWeapon = pkg.ReadInt();
				proxyPlayer.StrengthLevel = pkg.ReadInt();
				proxyPlayer.Healstone = pkg.ReadInt();
				proxyPlayer.HealstoneCount = pkg.ReadInt();
				double num4 = pkg.ReadDouble();
				double num7 = pkg.ReadDouble();
				double num8 = pkg.ReadDouble();
				double num9 = pkg.ReadDouble();
				double num10 = pkg.ReadDouble();
				pkg.ReadInt();
				List<BufferInfo> buffers = new List<BufferInfo>();
				int num11 = pkg.ReadInt();
				for (int index4 = 0; index4 < num11; index4++)
				{
					BufferInfo bufferInfo = new BufferInfo();
					bufferInfo.Type = pkg.ReadInt();
					bufferInfo.IsExist = pkg.ReadBoolean();
					bufferInfo.BeginDate = pkg.ReadDateTime();
					bufferInfo.ValidDate = pkg.ReadInt();
					bufferInfo.Value = pkg.ReadInt();
					if (character != null)
					{
						buffers.Add(bufferInfo);
					}
				}
				List<int> equipEffect = new List<int>();
				int num13 = pkg.ReadInt();
				for (int index3 = 0; index3 < num13; index3++)
				{
					int num14 = pkg.ReadInt();
					equipEffect.Add(num14);
				}
				List<BufferInfo> fightBuffer = new List<BufferInfo>();
				int num16 = pkg.ReadInt();
				for (int index2 = 0; index2 < num16; index2++)
				{
					int num12 = pkg.ReadInt();
					int num17 = pkg.ReadInt();
					fightBuffer.Add(new BufferInfo
					{
						Type = num12,
						Value = num17
					});
				}
				UserMatchInfo matchInfo = new UserMatchInfo();
				character.typeVIP = pkg.ReadByte();
				character.VIPLevel = pkg.ReadInt();
				character.VIPExpireDay = pkg.ReadDateTime();
				matchInfo.DailyLeagueFirst = pkg.ReadBoolean();
				matchInfo.DailyLeagueLastScore = pkg.ReadInt();
				int num6 = (pkg.ReadBoolean() ? 1 : 0);
				UsersPetInfo pet = null;
				if (num6 != 0)
				{
					pet = new UsersPetInfo();
					pet.Place = pkg.ReadInt();
					pet.TemplateID = pkg.ReadInt();
					pet.ID = pkg.ReadInt();
					pet.Name = pkg.ReadString();
					pet.UserID = pkg.ReadInt();
					pet.Level = pkg.ReadInt();
					pet.Skill = pkg.ReadString();
					pet.SkillEquip = pkg.ReadString();
				}
				List<int> CardBuff = new List<int>();
				int countCard = pkg.ReadInt();
				for (int i = 0; i < countCard; i++)
				{
					CardBuff.Add(pkg.ReadInt());
				}
				players[index1] = new ProxyPlayer(this, character, pet, buffers, equipEffect, fightBuffer, proxyPlayer, matchInfo)
				{
					CurrentEnemyId = num3,
					GPApprenticeOnline = num8,
					GPAddPlus = num4,
					OfferAddPlus = num7,
					GPApprenticeTeam = num9,
					GPSpouseTeam = num10,
					CardBuff = CardBuff,
					IsViewer = isViewer
				};
				if (character.Grade > maxLevel)
                {
					maxLevel = character.Grade;
					num22 = character.ID;
				}
				num21 += character.Grade;
			}
			ProxyRoom room = new ProxyRoom(ProxyRoomMgr.NextRoomId(), num1, zoneID, players, this, npcId, pickUpWithNPC, isBot, isSmartBot: false);
			room.GuildId = num20;
			room.selfId = num22;
			room.AvgLevel = num21;
			room.startWithNpc = pickUpWithNPC;
			room.RoomType = (eRoomType)num18;
			room.GameType = (eGameType)num19;
			room.IsCrossZone = flag;
			room.FightPower = num2;
			lock (m_rooms)
			{
				if (!m_rooms.ContainsKey(num1))
				{
					m_rooms.Add(num1, room);
				}
				else
				{
					room = null;
				}
			}
			if (room != null)
			{
				ProxyRoomMgr.AddRoom(room);
				return;
			}
			RemoveRoom(num1, room);
			ilog_1.ErrorFormat("Room already exists:{0}.", num1);
        }

        public void HandleGameRoomCancel(GSPacketIn pkg)
        {
			ProxyRoom room = null;
			lock (m_rooms)
			{
				if (m_rooms.ContainsKey(pkg.Parameter1))
				{
					room = m_rooms[pkg.Parameter1];
				}
			}
			if (room != null)
			{
				ProxyRoomMgr.RemoveRoom(room);
			}
        }

        public void HanleSendToGame(GSPacketIn pkg)
        {
			BaseGame game = GameMgr.FindGame(pkg.ClientID);
			if (game != null)
			{
				GSPacketIn pkg2 = pkg.ReadPacket();
				game.ProcessData(pkg2);
			}
        }

        public void SendRSAKey(byte[] m, byte[] e)
        {
			GSPacketIn pkg = new GSPacketIn(0);
			pkg.Write(m);
			pkg.Write(e);
			SendTCP(pkg);
        }

        public void SendPacketToPlayer(int playerId, GSPacketIn pkg)
        {
			GSPacketIn p = new GSPacketIn(32, playerId);
			p.WritePacket(pkg);
			SendTCP(p);
        }

        public void SendRemoveRoom(int roomId)
        {
			GSPacketIn pkg = new GSPacketIn(65, roomId);
			SendTCP(pkg);
        }

        public void SendToRoom(int roomId, GSPacketIn pkg, IGamePlayer except)
        {
			GSPacketIn p = new GSPacketIn(67, roomId);
			if (except != null)
			{
				p.Parameter1 = except.PlayerCharacter.ID;
				p.Parameter2 = except.GamePlayerId;
			}
			else
			{
				p.Parameter1 = 0;
				p.Parameter2 = 0;
			}
			p.WritePacket(pkg);
			SendTCP(p);
        }

        public void SendStartGame(int roomId, AbstractGame game)
        {
			GSPacketIn pkg = new GSPacketIn(66);
			pkg.Parameter1 = roomId;
			pkg.Parameter2 = game.Id;
			pkg.WriteInt((int)game.RoomType);
			pkg.WriteInt((int)game.GameType);
			pkg.WriteInt(game.TimeType);
			SendTCP(pkg);
        }

        public void SendStopGame(int roomId, int gameId)
        {
			GSPacketIn pkg = new GSPacketIn(68);
			pkg.Parameter1 = roomId;
			pkg.Parameter2 = gameId;
			SendTCP(pkg);
        }

        public void SendGamePlayerId(IGamePlayer player)
        {
			GSPacketIn pkg = new GSPacketIn(33);
			pkg.Parameter1 = player.PlayerCharacter.ID;
			pkg.Parameter2 = player.GamePlayerId;
			SendTCP(pkg);
        }

        public void SendAddRobRiches(int playerId, int value)
        {
			GSPacketIn pkg = new GSPacketIn(52, playerId);
			pkg.Parameter1 = value;
			pkg.WriteInt(value);
			SendTCP(pkg);
        }

        public void SendPlayerAddOffer(int playerId, int value)
        {
			GSPacketIn pkg = new GSPacketIn(51, playerId);
			pkg.Parameter1 = value;
			SendTCP(pkg);
        }

        public void SendDisconnectPlayer(int playerId)
        {
			GSPacketIn pkg = new GSPacketIn(34, playerId);
			SendTCP(pkg);
        }

        public void SendPlayerOnGameOver(int playerId, int gameId, bool isWin, int gainXp, bool isSpanArea, bool isCouple, int blood, int playerCount)
        {
			GSPacketIn pkg = new GSPacketIn(35, playerId)
			{
				Parameter1 = gameId
			};
			pkg.WriteBoolean(isWin);
			pkg.WriteInt(gainXp);
			pkg.WriteBoolean(isSpanArea);
			pkg.WriteBoolean(isCouple);
			pkg.WriteInt(blood);
			pkg.WriteInt(playerCount);
			SendTCP(pkg);
        }

        public void SendPlayerUsePropInGame(int playerId, int bag, int place, int templateId, bool isLiving)
        {
			GSPacketIn pkg = new GSPacketIn(36, playerId);
			pkg.Parameter1 = bag;
			pkg.Parameter2 = place;
			pkg.WriteInt(templateId);
			pkg.WriteBoolean(isLiving);
			SendTCP(pkg);
        }

        public void SendAddEliteGameScore(int playerId, int value)
        {
			SendTCP(new GSPacketIn(204, playerId)
			{
				Parameter1 = value
			});
        }

        public void SendRemoveEliteGameScore(int playerId, int value)
        {
			SendTCP(new GSPacketIn(205, playerId)
			{
				Parameter1 = value
			});
        }

        public void SendEliteGameWinUpdate(int playerId)
        {
			SendTCP(new GSPacketIn(206, playerId));
        }

        public void SendPlayerAddGold(int playerId, int value)
        {
			GSPacketIn pkg = new GSPacketIn(38, playerId);
			pkg.Parameter1 = value;
			SendTCP(pkg);
        }

        public void SendPlayerAddMoney(int playerId, int value, bool isAll)
        {
			GSPacketIn pkg = new GSPacketIn(74, playerId);
			pkg.Parameter1 = value;
			pkg.Parameter2 = (isAll ? 1 : 0);
			SendTCP(pkg);
        }

        public void SendPlayerAddGiftToken(int playerId, int value)
        {
			GSPacketIn pkg = new GSPacketIn(75, playerId);
			pkg.Parameter1 = value;
			SendTCP(pkg);
        }

        public void SendPlayerAddGP(int playerId, int value)
        {
			GSPacketIn pkg = new GSPacketIn(39, playerId);
			pkg.Parameter1 = value;
			SendTCP(pkg);
        }

        public void SendPlayerRemoveGP(int playerId, int value)
        {
			GSPacketIn pkg = new GSPacketIn(49, playerId);
			pkg.Parameter1 = value;
			SendTCP(pkg);
        }

        public void SendUpdateRestCount(int playerId)
        {
			GSPacketIn pkg = new GSPacketIn(86, playerId);
			SendTCP(pkg);
        }

        public void SendPlayerOnKillingLiving(int playerId, AbstractGame game, int type, int id, bool isLiving, int demage)
        {
			GSPacketIn pkg = new GSPacketIn(40, playerId);
			pkg.WriteInt(type);
			pkg.WriteBoolean(isLiving);
			pkg.WriteInt(demage);
			SendTCP(pkg);
        }

        public void SendPlayerOnMissionOver(int playerId, AbstractGame game, bool isWin, int MissionID, int turnNum)
        {
			GSPacketIn pkg = new GSPacketIn(41, playerId);
			pkg.WriteBoolean(isWin);
			pkg.WriteInt(MissionID);
			pkg.WriteInt(turnNum);
			SendTCP(pkg);
        }

        public void SendPlayerConsortiaFight(int playerId, int consortiaWin, int consortiaLose, Dictionary<int, Player> players, eRoomType roomType, eGameType gameClass, int totalKillHealth)
        {
			try
			{
				GSPacketIn pkg = new GSPacketIn(42, playerId);
				pkg.WriteInt(consortiaWin);
				pkg.WriteInt(consortiaLose);
				pkg.WriteInt(players.Count);
				for (int i = 0; i < players.Count; i++)
				{
					pkg.WriteInt(players[i].PlayerDetail.PlayerCharacter.ID);
				}
				pkg.WriteByte((byte)roomType);
				pkg.WriteByte((byte)gameClass);
				pkg.WriteInt(totalKillHealth);
				SendTCP(pkg);
			}
			catch
			{
				ilog_1.ErrorFormat("SendPlayerConsortiaFight players.Count {0}", players.Count);
			}
        }

        public void SendPlayerSendConsortiaFight(int playerId, int consortiaID, int riches, string msg)
        {
			GSPacketIn pkg = new GSPacketIn(43, playerId);
			pkg.WriteInt(consortiaID);
			pkg.WriteInt(riches);
			pkg.WriteString(msg);
			SendTCP(pkg);
        }

        public void SendPlayerRemoveGold(int playerId, int value)
        {
			GSPacketIn pkg = new GSPacketIn(44, playerId);
			pkg.WriteInt(value);
			SendTCP(pkg);
        }

        public void SendPlayerRemoveMoney(int playerId, int value)
        {
			GSPacketIn pkg = new GSPacketIn(45, playerId);
			pkg.WriteInt(value);
			SendTCP(pkg);
        }

        public void SendPlayerRemoveOffer(int playerId, int value)
        {
			GSPacketIn pkg = new GSPacketIn(50, playerId);
			pkg.WriteInt(value);
			SendTCP(pkg);
        }

        public void SendPlayerAddTemplate(int playerId, ItemInfo cloneItem, eBageType bagType, int count)
        {
			if (cloneItem != null)
			{
				GSPacketIn pkg = new GSPacketIn(48, playerId);
				pkg.WriteInt(cloneItem.TemplateID);
				pkg.WriteByte((byte)bagType);
				pkg.WriteInt(count);
				pkg.WriteInt(cloneItem.ValidDate);
				pkg.WriteBoolean(cloneItem.IsBinds);
				pkg.WriteBoolean(cloneItem.IsUsed);
				pkg.WriteInt(cloneItem.StrengthenLevel);
				pkg.WriteInt(cloneItem.AttackCompose);
				pkg.WriteInt(cloneItem.DefendCompose);
				pkg.WriteInt(cloneItem.AgilityCompose);
				pkg.WriteInt(cloneItem.LuckCompose);
				pkg.WriteBoolean(cloneItem.IsGold);
				if (cloneItem.IsGold)
				{
					pkg.WriteDateTime(cloneItem.goldBeginTime);
					pkg.WriteInt(cloneItem.goldValidDate);
				}
				SendTCP(pkg);
			}
        }

        public void SendConsortiaAlly(int Consortia1, int Consortia2, int GameId)
        {
			GSPacketIn pkg = new GSPacketIn(77);
			pkg.WriteInt(Consortia1);
			pkg.WriteInt(Consortia2);
			pkg.WriteInt(GameId);
			SendTCP(pkg);
        }

        public void SendBeginFightNpc(int playerId, int RoomType, int GameType, int OrientRoomId, int countPlayer = 1)
        {
			GSPacketIn pkg = new GSPacketIn(88);
			pkg.Parameter1 = playerId;
			pkg.WriteInt(RoomType);
			pkg.WriteInt(GameType);
			pkg.WriteInt(OrientRoomId);
			pkg.WriteInt(countPlayer);
			SendTCP(pkg);
        }

        public void SendPlayerRemoveHealstone(int playerId)
        {
			GSPacketIn pkg = new GSPacketIn(73, playerId);
			SendTCP(pkg);
        }

        public ServerClient(FightServer svr)
			: base(new byte[8192], new byte[8192])
        {
			m_svr = svr;
        }

        public override string ToString()
        {
			return $"Server Client: {0} IsConnected:{base.IsConnected}  RoomCount:{m_rooms.Count}";
        }

        public void RemoveRoom(int orientId, ProxyRoom room)
        {
			bool flag = false;
			lock (m_rooms)
			{
				if (m_rooms.ContainsKey(orientId) && m_rooms[orientId] == room)
				{
					flag = m_rooms.Remove(orientId);
				}
			}
			if (flag)
			{
				SendRemoveRoom(orientId);
			}
        }

		public void SendUpdatePublicPlayer(int playerId, string tempStyle)
		{
			GSPacketIn send = new GSPacketIn((short)301, playerId);
			send.WriteString(tempStyle);
			SendTCP(send);
		}

		public void SendPlayerAddPrestige(int playerId, bool isWin, eRoomType roomType)
		{
			GSPacketIn pkg = new GSPacketIn((byte)eFightPackageType.PLAYER_ADD_PRESTIGE, playerId);
			pkg.Parameter1 = (int)roomType;
			pkg.WriteBoolean(isWin);
			SendTCP(pkg);
		}

		static ServerClient()
        {
			ilog_1 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        }
    }
}
