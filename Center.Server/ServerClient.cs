using Bussiness;
using Bussiness.Protocol;
using Center.Server.Managers;
using Game.Base;
using Game.Base.Packets;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;

namespace Center.Server
{
    public class ServerClient : BaseClient
    {
        private RSACryptoServiceProvider _rsa;

        private CenterServer _svr;

        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public bool NeedSyncMacroDrop;

        public ServerInfo Info { get; set; }

        public ServerClient(CenterServer svr)
			: base(new byte[8192], new byte[8192])
        {
			_svr = svr;
        }

        public void HandkeItemStrengthen(GSPacketIn pkg)
        {
			_svr.SendToALL(pkg, this);
        }

        public void HandleBigBugle(GSPacketIn pkg)
        {
			_svr.SendToALL(pkg, this);
        }

		public void HandleBuyBadge(GSPacketIn pkg)
        {
			pkg.ReadInt();
			_svr.SendToALL(pkg, null);
        }

        public void HandleConsortiaCreate(GSPacketIn pkg)
        {
			pkg.ReadInt();
			pkg.ReadInt();
			_svr.SendToALL(pkg, null);
        }

        public void HandleConsortiaFight(GSPacketIn pkg)
        {
			_svr.SendToALL(pkg);
        }

        public void HandleConsortiaOffer(GSPacketIn pkg)
        {
			pkg.ReadInt();
			pkg.ReadInt();
			pkg.ReadInt();
        }

        public void HandleConsortiaResponse(GSPacketIn pkg)
        {
			int num = pkg.ReadByte();
			_svr.SendToALL(pkg, null);
        }

        public void HandleConsortiaUpGrade(GSPacketIn pkg)
        {
			_svr.SendToALL(pkg, this);
        }

        public void HandleChatConsortia(GSPacketIn pkg)
        {
			_svr.SendToALL(pkg, this);
        }

        public void HandleChatPersonal(GSPacketIn pkg)
        {
			_svr.SendToALL(pkg);
        }

        public void HandleChatScene(GSPacketIn pkg)
        {
			if (pkg.ReadByte() == 3)
			{
				HandleChatConsortia(pkg);
			}
        }

        public void HandleFirendResponse(GSPacketIn pkg)
        {
			_svr.SendToALL(pkg, this);
        }

        public void HandleFriend(GSPacketIn pkg)
        {
			_svr.SendToALL(pkg, this);
        }

        public void HandleFriendState(GSPacketIn pkg)
        {
			_svr.SendToALL(pkg, this);
        }

        public void HandleIPAndPort(GSPacketIn pkg)
        {
        }

        public void HandleLogin(GSPacketIn pkg)
        {
			byte[] rgb = pkg.ReadBytes();
			string[] strArray = Encoding.UTF8.GetString(_rsa.Decrypt(rgb, fOAEP: false)).Split(',');
			if (strArray.Length != 2)
			{
				log.ErrorFormat("Error Login Packet from {0}", base.TcpEndpoint);
				Disconnect();
				return;
			}
			_rsa = null;
			int id = int.Parse(strArray[0]);
			Info = ServerMgr.GetServerInfo(id);
			if (Info == null || Info.State != 1)
			{
				log.ErrorFormat("Error Login Packet from {0} want to login serverid:{1}", base.TcpEndpoint, id);
				Disconnect();
				return;
			}
			base.Strict = false;
			CenterServer.Instance.SendConfigState();
			CenterServer.Instance.SendUpdateWorldEvent();
			Info.Online = 0;
			Info.State = 2;
        }

        public void HandleMacroDrop(GSPacketIn pkg)
        {
			Dictionary<int, int> temp = new Dictionary<int, int>();
			int num = pkg.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int key = pkg.ReadInt();
				int num2 = pkg.ReadInt();
				temp.Add(key, num2);
			}
			MacroDropMgr.DropNotice(temp);
			NeedSyncMacroDrop = true;
        }

        public void HandleMailResponse(GSPacketIn pkg)
        {
			int playerid = pkg.ReadInt();
			HandleUserPrivateMsg(pkg, playerid);
        }

        public void HandleMarryRoomInfoToPlayer(GSPacketIn pkg)
        {
			Player player = LoginMgr.GetPlayer(pkg.ReadInt());
			if (player != null && player.CurrentServer != null)
			{
				player.CurrentServer.SendTCP(pkg);
			}
        }

        public void HandlePing(GSPacketIn pkg)
        {
			Info.Online = pkg.ReadInt();
			Info.State = ServerMgr.GetState(Info.Online, Info.Total);
        }

        public void HandleQuestUserState(GSPacketIn pkg)
        {
			int playerId = pkg.ReadInt();
			if (LoginMgr.GetServerClient(playerId) == null)
			{
				SendUserState(playerId, state: false);
			}
			else
			{
				SendUserState(playerId, state: true);
			}
        }

        public void HandleRecvConsortiaBossAdd(GSPacketIn pkg)
        {
			ConsortiaInfo consortia = new ConsortiaInfo
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
				LastOpenBoss = pkg.ReadDateTime()
			};
			if (!ConsortiaBossMgr.AddConsortia(consortia.ConsortiaID, consortia))
			{
				consortia = ConsortiaBossMgr.GetConsortiaById(consortia.ConsortiaID);
			}
			HandleSendConsortiaBossInfo(consortia, 180);
        }

        public void HandleRecvConsortiaBossCreate(GSPacketIn pkg)
        {
			int consortiaId = pkg.ReadInt();
			byte bossState = pkg.ReadByte();
			DateTime endTime = pkg.ReadDateTime();
			DateTime lastOpenBoss = pkg.ReadDateTime();
			long maxBlood = pkg.ReadInt();
			if (ConsortiaBossMgr.UpdateConsortia(consortiaId, bossState, endTime, lastOpenBoss, maxBlood))
			{
				ConsortiaInfo consortiaById = ConsortiaBossMgr.GetConsortiaById(consortiaId);
				if (consortiaById != null)
				{
					HandleSendConsortiaBossInfo(consortiaById, 183);
				}
			}
        }

        public void HandleRecvConsortiaBossExtendAvailable(GSPacketIn pkg)
        {
			int consortiaId = pkg.ReadInt();
			int riches = pkg.ReadInt();
			if (ConsortiaBossMgr.ExtendAvailable(consortiaId, riches))
			{
				ConsortiaInfo consortiaById = ConsortiaBossMgr.GetConsortiaById(consortiaId);
				if (consortiaById != null)
				{
					HandleSendConsortiaBossInfo(consortiaById, 182);
				}
			}
			else
			{
				ConsortiaInfo consortia = ConsortiaBossMgr.GetConsortiaById(consortiaId);
				if (consortia != null)
				{
					HandleSendConsortiaBossInfo(consortia, 184);
				}
			}
        }

        public void HandleRecvConsortiaBossReload(GSPacketIn pkg)
        {
			ConsortiaInfo consortiaById = ConsortiaBossMgr.GetConsortiaById(pkg.ReadInt());
			if (consortiaById == null)
			{
				return;
			}
			if (consortiaById.bossState == 2 && consortiaById.SendToClient)
			{
				if (consortiaById.IsBossDie)
				{
					HandleSendConsortiaBossInfo(consortiaById, 188);
				}
				else
				{
					HandleSendConsortiaBossInfo(consortiaById, 187);
				}
				ConsortiaBossMgr.UpdateSendToClient(consortiaById.ConsortiaID);
			}
			else
			{
				HandleSendConsortiaBossInfo(consortiaById, 184);
			}
        }

        public void HandleRecvConsortiaBossUpdateBlood(GSPacketIn pkg)
        {
			int consortiaId = pkg.ReadInt();
			int damage = pkg.ReadInt();
			ConsortiaBossMgr.UpdateBlood(consortiaId, damage);
        }

        public void HandleRecvConsortiaBossUpdateRank(GSPacketIn pkg)
        {
			int consortiaId = pkg.ReadInt();
			int damage = pkg.ReadInt();
			int richer = pkg.ReadInt();
			int honor = pkg.ReadInt();
			string nickName = pkg.ReadString();
			int userID = pkg.ReadInt();
			ConsortiaBossMgr.UpdateRank(consortiaId, damage, richer, honor, nickName, userID);
        }

        public void HandleReload(GSPacketIn pkg)
        {
			eReloadType type = (eReloadType)pkg.ReadInt();
			int num = pkg.ReadInt();
			bool flag = pkg.ReadBoolean();
            Console.WriteLine(num + " " + type.ToString() + " is reload " + (flag ? "succeed!" : "fail"));
        }

        public void HandleSendConsortiaBossInfo(ConsortiaInfo consortia, byte code)
        {
			GSPacketIn pkg = new GSPacketIn(180);
			pkg.WriteInt(consortia.ConsortiaID);
			pkg.WriteInt(consortia.ChairmanID);
			pkg.WriteByte((byte)consortia.bossState);
			pkg.WriteDateTime(consortia.endTime);
			pkg.WriteInt(consortia.extendAvailableNum);
			pkg.WriteInt(consortia.callBossLevel);
			pkg.WriteInt(consortia.Level);
			pkg.WriteInt(consortia.SmithLevel);
			pkg.WriteInt(consortia.StoreLevel);
			pkg.WriteInt(consortia.SkillLevel);
			pkg.WriteInt(consortia.Riches);
			pkg.WriteDateTime(consortia.LastOpenBoss);
			pkg.WriteLong(consortia.MaxBlood);
			pkg.WriteLong(consortia.TotalAllMemberDame);
			pkg.WriteBoolean(consortia.IsBossDie);
			List<RankingPersonInfo> list = ConsortiaBossMgr.SelectRank(consortia.ConsortiaID);
			pkg.WriteInt(list.Count);
			int val = 1;
			foreach (RankingPersonInfo info in list)
			{
				pkg.WriteString(info.Name);
				pkg.WriteInt(val);
				pkg.WriteInt(info.TotalDamage);
				pkg.WriteInt(info.Honor);
				pkg.WriteInt(info.Damage);
				val++;
			}
			pkg.WriteByte(code);
			_svr.SendToALL(pkg);
        }

        public void HandleShutdown(GSPacketIn pkg)
        {
			int num = pkg.ReadInt();
			if (pkg.ReadBoolean())
			{
				Console.WriteLine(num + "  begin stoping !");
			}
			else
			{
				Console.WriteLine(num + "  is stoped !");
			}
        }

        public void HandleUpdatePlayerState(GSPacketIn pkg)
        {
			Player player = LoginMgr.GetPlayer(pkg.ReadInt());
			if (player != null && player.CurrentServer != null)
			{
				player.CurrentServer.SendTCP(pkg);
			}
        }

        private void HandleUserLogin(GSPacketIn pkg)
        {
			int id = pkg.ReadInt();
			if (LoginMgr.TryLoginPlayer(id, this))
			{
				SendAllowUserLogin(id, allow: true);
			}
			else
			{
				SendAllowUserLogin(id, allow: false);
			}
        }

        private void HandleUserOffline(GSPacketIn pkg)
        {
			new List<int>();
			int num = pkg.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int id = pkg.ReadInt();
				pkg.ReadInt();
				LoginMgr.PlayerLoginOut(id, this);
			}
			_svr.SendToALL(pkg);
        }

        private void HandleUserOnline(GSPacketIn pkg)
        {
			int num = pkg.ReadInt();
			for (int i = 0; i < num; i++)
			{
				int id = pkg.ReadInt();
				pkg.ReadInt();
				LoginMgr.PlayerLogined(id, this);
			}
			_svr.SendToALL(pkg, this);
        }

        private void HandleUserPrivateMsg(GSPacketIn pkg, int playerid)
        {
			LoginMgr.GetServerClient(playerid)?.SendTCP(pkg);
        }

        public void HandleUserPublicMsg(GSPacketIn pkg)
        {
			_svr.SendToALL(pkg, this);
        }

        public void HandleWorldBossFightOver(GSPacketIn pkg)
        {
			WorldMgr.WorldBossFightOver();
			_svr.SendWorldBossFightOver();
        }

        public void HandleWorldBossPrivateInfo(GSPacketIn pkg)
        {
			string name = pkg.ReadString();
			_svr.SendPrivateInfo(name);
        }

        public void HandleWorldBossRank(GSPacketIn pkg, bool update)
        {
			if (update)
			{
				int damage = pkg.ReadInt();
				int honor = pkg.ReadInt();
				string nickName = pkg.ReadString();
				WorldMgr.UpdateRank(damage, honor, nickName);
			}
			_svr.SendUpdateRank(type: false);
        }

        public void HandleWorldBossRoomClose(GSPacketIn pkg)
        {
			WorldMgr.WorldBossRoomClose();
			_svr.SendRoomClose(0);
        }

        public void HandleWorldBossUpdateBlood(GSPacketIn pkg)
        {
			int num = pkg.ReadInt();
			if (num > 0)
			{
				WorldMgr.ReduceBlood(num);
			}
			_svr.SendUpdateWorldBlood();
        }

        protected override void OnConnect()
        {
			base.OnConnect();
			_rsa = new RSACryptoServiceProvider();
			RSAParameters parameters = _rsa.ExportParameters(includePrivateParameters: false);
			SendRSAKey(parameters.Modulus, parameters.Exponent);
        }

        protected override void OnDisconnect()
        {
			base.OnDisconnect();
			_rsa = null;
			List<Player> serverPlayers = LoginMgr.GetServerPlayers(this);
			LoginMgr.RemovePlayer(serverPlayers);
			SendUserOffline(serverPlayers);
			if (Info != null)
			{
				Info.State = 1;
				Info.Online = 0;
				Info = null;
			}
        }

        public override void OnRecvPacket(GSPacketIn pkg)
        {
			short code = pkg.Code;
			if (code <= 91)
			{
				if (code <= 37)
				{
					switch (code)
					{
					case 1:
						HandleLogin(pkg);
						return;
					case 2:
					case 7:
					case 8:
					case 9:
					case 16:
					case 17:
					case 18:
						return;
					case 3:
						HandleUserLogin(pkg);
						return;
					case 4:
						HandleUserOffline(pkg);
						return;
					case 5:
						HandleUserOnline(pkg);
						return;
					case 6:
						HandleQuestUserState(pkg);
						return;
					case 10:
						HandkeItemStrengthen(pkg);
						return;
					case 11:
						HandleReload(pkg);
						return;
					case 12:
						HandlePing(pkg);
						return;
					case 13:
						HandleUpdatePlayerState(pkg);
						return;
					case 14:
						HandleMarryRoomInfoToPlayer(pkg);
						return;
					case 15:
						HandleShutdown(pkg);
						return;
					case 19:
						HandleChatScene(pkg);
						return;
					}
					if (code == 37)
					{
						HandleChatPersonal(pkg);
					}
				}
				else
				{
					switch (code)
					{
					case 81:
						HandleWorldBossRank(pkg, update: true);
						break;
					case 82:
						HandleWorldBossFightOver(pkg);
						break;
					case 83:
						HandleWorldBossRoomClose(pkg);
						break;
					case 84:
						HandleWorldBossUpdateBlood(pkg);
						break;
					case 85:
						HandleWorldBossPrivateInfo(pkg);
						break;
					case 86:
						HandleWorldBossRank(pkg, update: false);
						break;
					case 72:
					case 73:
						HandleBigBugle(pkg);
						break;
					}
				}
				return;
			}
			if (code <= 130)
			{
				switch (code)
				{
				case 128:
					HandleConsortiaResponse(pkg);
					break;
				case 130:
					HandleConsortiaCreate(pkg);
					break;
				case 117:
					HandleMailResponse(pkg);
					break;
				}
				return;
			}
			switch (code)
			{
			case 156:
				HandleConsortiaOffer(pkg);
				return;
			case 157:
			case 159:
			case 179:
			case 185:
				return;
			case 158:
				HandleConsortiaFight(pkg);
				return;
			case 160:
				HandleFriend(pkg);
				return;
			case 178:
				HandleMacroDrop(pkg);
				return;
			case 180:
				HandleRecvConsortiaBossAdd(pkg);
				return;
			case 181:
				HandleRecvConsortiaBossUpdateRank(pkg);
				return;
			case 182:
				HandleRecvConsortiaBossExtendAvailable(pkg);
				return;
			case 183:
				HandleRecvConsortiaBossCreate(pkg);
				return;
			case 184:
				HandleRecvConsortiaBossReload(pkg);
				return;
			case 186:
				HandleRecvConsortiaBossUpdateBlood(pkg);
				return;
			}
			if (code == 240)
			{
				HandleIPAndPort(pkg);
			}
        }

        public void SendAllowUserLogin(int playerid, bool allow)
        {
			GSPacketIn pkg = new GSPacketIn(3);
			pkg.WriteInt(playerid);
			pkg.WriteBoolean(allow);
			SendTCP(pkg);
        }

        public void SendASS(bool state)
        {
			GSPacketIn pkg = new GSPacketIn(7);
			pkg.WriteBoolean(state);
			SendTCP(pkg);
        }

        public void SendChargeMoney(int player, string chargeID)
        {
			GSPacketIn pkg = new GSPacketIn(9, player);
			pkg.WriteString(chargeID);
			SendTCP(pkg);
        }

        public void SendKitoffUser(int playerid)
        {
			SendKitoffUser(playerid, LanguageMgr.GetTranslation("Center.Server.SendKitoffUser"));
        }

        public void SendKitoffUser(int playerid, string msg)
        {
			GSPacketIn pkg = new GSPacketIn(2);
			pkg.WriteInt(playerid);
			pkg.WriteString(msg);
			SendTCP(pkg);
        }

        public void SendRSAKey(byte[] m, byte[] e)
        {
			GSPacketIn pkg = new GSPacketIn(0);
			pkg.Write(m);
			pkg.Write(e);
			SendTCP(pkg);
        }

        public void SendUserOffline(List<Player> users)
        {
			for (int i = 0; i < users.Count; i += 100)
			{
				int val = ((i + 100 > users.Count) ? (users.Count - i) : 100);
				GSPacketIn pkg = new GSPacketIn(4);
				pkg.WriteInt(val);
				for (int j = i; j < i + val; j++)
				{
					pkg.WriteInt(users[j].Id);
					pkg.WriteInt(0);
				}
				SendTCP(pkg);
				_svr.SendToALL(pkg, this);
			}
        }

        public void SendUserState(int player, bool state)
        {
			GSPacketIn pkg = new GSPacketIn(6, player);
			pkg.WriteBoolean(state);
			SendTCP(pkg);
        }
	}
}
