using Game.Base.Packets;
using Game.Server.LittleGame.Objects;
using System.Collections.Generic;

namespace Game.Server.LittleGame
{
    public class LittleGamePacketsOut
    {
        public void SendEnterWorld(GamePlayer player)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166, player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(2);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteString("bogu1,bogu2,bogu3,bogu4,bogu5,bogu6,bogu7,bogu8");
			gSPacketIn.WriteString("2001");
			player.SendTCP(gSPacketIn);
        }

        public void SendLoadComplete(GamePlayer player, Dictionary<int, object> obj)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166, player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(3);
			gSPacketIn.WriteInt(obj.Values.Count);
			foreach (object value in obj.Values)
			{
				GamePlayer gamePlayer = value as GamePlayer;
				if (gamePlayer != null)
				{
					gSPacketIn.WriteInt(gamePlayer.LittleGameInfo.ID);
					gSPacketIn.WriteInt(gamePlayer.LittleGameInfo.X);
					gSPacketIn.WriteInt(gamePlayer.LittleGameInfo.Y);
					gSPacketIn.WriteInt(1);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.ID);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Grade);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Repute);
					gSPacketIn.WriteString(gamePlayer.PlayerCharacter.NickName);
					gSPacketIn.WriteByte(gamePlayer.PlayerCharacter.typeVIP);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.VIPLevel);
					gSPacketIn.WriteBoolean(gamePlayer.PlayerCharacter.Sex);
					gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Style);
					gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Colors);
					gSPacketIn.WriteString(gamePlayer.PlayerCharacter.Skin);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Hide);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.FightPower);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Win);
					gSPacketIn.WriteInt(gamePlayer.PlayerCharacter.Total);
					gSPacketIn.WriteBoolean(val: false);
					gSPacketIn.WriteInt(gamePlayer.LittleGameInfo.Actions.Count);
					foreach (string action in gamePlayer.LittleGameInfo.Actions)
					{
						string text = action;
						string a = text;
						if (!(a == "livingInhale"))
						{
							if (a == "livingUnInhale")
							{
								gSPacketIn.WriteString("livingUnInhale");
								gSPacketIn.WriteInt(gamePlayer.LittleGameInfo.ID);
								gSPacketIn.WriteString("stand");
								gSPacketIn.WriteString(player.LittleGameInfo.Direction);
							}
						}
						else
						{
							gSPacketIn.WriteString("livingInhale");
							gSPacketIn.WriteInt(gamePlayer.LittleGameInfo.ID);
							gSPacketIn.WriteString((!player.LittleGameInfo.IsBack) ? "inhaleSmall" : "backInhaleSmall");
							gSPacketIn.WriteString(player.LittleGameInfo.Direction);
							gSPacketIn.WriteInt(10);
							gSPacketIn.WriteInt(gamePlayer.LittleGameInfo.X);
							gSPacketIn.WriteInt(gamePlayer.LittleGameInfo.Y);
						}
					}
				}
				Bogu bogu = value as Bogu;
				if (bogu != null)
				{
					gSPacketIn.WriteInt(bogu.ID);
					gSPacketIn.WriteInt(bogu.X);
					gSPacketIn.WriteInt(bogu.Y);
					gSPacketIn.WriteInt(2);
					gSPacketIn.WriteString("温泉小游戏");
					gSPacketIn.WriteString(bogu.Model);
					gSPacketIn.WriteBoolean(val: true);
					gSPacketIn.WriteInt(bogu.X);
					gSPacketIn.WriteInt(bogu.Y);
					gSPacketIn.WriteInt((bogu.Action != "") ? 1 : 0);
					switch (bogu.Action)
					{
					case "livingInhale":
						gSPacketIn.WriteString("livingInhale");
						gSPacketIn.WriteInt(bogu.ID);
						gSPacketIn.WriteString((!bogu.IsBack) ? "inhaled" : ((bogu.Size == 0) ? "backInhaled" : "inhaled"));
						gSPacketIn.WriteString(bogu.Direction);
						gSPacketIn.WriteInt(10);
						gSPacketIn.WriteInt(bogu.X);
						gSPacketIn.WriteInt(bogu.Y);
						break;
					case "livingUnInhale":
						gSPacketIn.WriteString("livingUnInhale");
						gSPacketIn.WriteInt(bogu.ID);
						gSPacketIn.WriteString("stand");
						gSPacketIn.WriteString(bogu.Direction);
						break;
					case "livingDie":
						gSPacketIn.WriteString("livingDie");
						gSPacketIn.WriteInt(bogu.ID);
						break;
					}
				}
			}
			player.SendTCP(gSPacketIn);
        }

        public void SendMoveToAll(GamePlayer player)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166);
			gSPacketIn.WriteByte(32);
			gSPacketIn.WriteInt(player.LittleGameInfo.ID);
			gSPacketIn.WriteInt(player.LittleGameInfo.X);
			gSPacketIn.WriteInt(player.LittleGameInfo.Y);
			SendToAll(gSPacketIn, player);
        }

        public void SendMoveToAll(Bogu bogu)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166);
			gSPacketIn.WriteByte(32);
			gSPacketIn.WriteInt(bogu.ID);
			gSPacketIn.WriteInt(bogu.X);
			gSPacketIn.WriteInt(bogu.Y);
			SendToAll(gSPacketIn);
        }

        public void SendActionToAll(GamePlayer player, string action = null)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166);
			gSPacketIn.WriteByte(96);
			string text = action ?? player.LittleGameInfo.Actions.Peek();
			string a = text;
			if (!(a == "livingInhale"))
			{
				if (a == "livingUnInhale")
				{
					gSPacketIn.WriteString("livingUnInhale");
					gSPacketIn.WriteInt(player.LittleGameInfo.ID);
					gSPacketIn.WriteString("stand");
					gSPacketIn.WriteString(player.LittleGameInfo.Direction);
				}
			}
			else
			{
				gSPacketIn.WriteString("livingInhale");
				gSPacketIn.WriteInt(player.LittleGameInfo.ID);
				gSPacketIn.WriteString((!player.LittleGameInfo.IsBack) ? "inhaleSmall" : "backInhaleSmall");
				gSPacketIn.WriteString(player.LittleGameInfo.Direction);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(player.LittleGameInfo.X);
				gSPacketIn.WriteInt(player.LittleGameInfo.Y);
			}
			SendToAll(gSPacketIn);
        }

        public void SendActionToAll(Bogu bogu, string action)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166);
			gSPacketIn.WriteByte(96);
			switch (action)
			{
			case "livingInhale":
				gSPacketIn.WriteString("livingInhale");
				gSPacketIn.WriteInt(bogu.ID);
				gSPacketIn.WriteString((!bogu.IsBack) ? "inhaled" : ((bogu.Size == 0) ? "backInhaled" : "inhaled"));
				gSPacketIn.WriteString(bogu.Direction);
				gSPacketIn.WriteInt(0);
				gSPacketIn.WriteInt(bogu.X);
				gSPacketIn.WriteInt(bogu.Y);
				break;
			case "livingUnInhale":
				gSPacketIn.WriteString("livingUnInhale");
				gSPacketIn.WriteInt(bogu.ID);
				gSPacketIn.WriteString((!bogu.Сaught) ? "stand" : ((!bogu.IsBack) ? "die" : ((bogu.Size == 0) ? "backDie" : "die")));
				gSPacketIn.WriteString(bogu.Direction);
				break;
			case "livingDie":
				gSPacketIn.WriteString("livingDie");
				gSPacketIn.WriteInt(bogu.ID);
				break;
			}
			SendToAll(gSPacketIn);
        }

        public void SendAddPlayerToAll(GamePlayer player)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166, player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(16);
			gSPacketIn.WriteInt(player.LittleGameInfo.ID);
			gSPacketIn.WriteInt(player.LittleGameInfo.X);
			gSPacketIn.WriteInt(player.LittleGameInfo.Y);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteInt(player.PlayerCharacter.ID);
			gSPacketIn.WriteInt(player.PlayerCharacter.Grade);
			gSPacketIn.WriteInt(player.PlayerCharacter.Repute);
			gSPacketIn.WriteString(player.PlayerCharacter.NickName);
			gSPacketIn.WriteByte(player.PlayerCharacter.typeVIP);
			gSPacketIn.WriteInt(player.PlayerCharacter.VIPLevel);
			gSPacketIn.WriteBoolean(player.PlayerCharacter.Sex);
			gSPacketIn.WriteString(player.PlayerCharacter.Style);
			gSPacketIn.WriteString(player.PlayerCharacter.Colors);
			gSPacketIn.WriteString(player.PlayerCharacter.Skin);
			gSPacketIn.WriteInt(player.PlayerCharacter.Hide);
			gSPacketIn.WriteInt(player.PlayerCharacter.FightPower);
			gSPacketIn.WriteInt(player.PlayerCharacter.Win);
			gSPacketIn.WriteInt(player.PlayerCharacter.Total);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteInt(0);
			SendToAll(gSPacketIn, player);
        }

        public void SendAddBoguToAll(Bogu bogu)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166);
			gSPacketIn.WriteByte(16);
			gSPacketIn.WriteInt(bogu.ID);
			gSPacketIn.WriteInt(bogu.X);
			gSPacketIn.WriteInt(bogu.Y);
			gSPacketIn.WriteInt(2);
			gSPacketIn.WriteString(bogu.Model);
			gSPacketIn.WriteString(bogu.Model);
			gSPacketIn.WriteBoolean(val: false);
			gSPacketIn.WriteInt(0);
			SendToAll(gSPacketIn);
        }

        public void SendLivingPropertyUpdateToAll(Bogu bogu, string property, string value)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166);
			gSPacketIn.WriteByte(90);
			gSPacketIn.WriteInt(bogu.ID);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteString(property);
			if (property == "lock")
			{
				gSPacketIn.WriteInt(2);
				gSPacketIn.WriteBoolean(bool.Parse(value));
			}
			SendToAll(gSPacketIn);
        }

        public void SendLivingPropertyUpdateToAll(GamePlayer player, string property, string value)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166);
			gSPacketIn.WriteByte(80);
			gSPacketIn.WriteInt(player.LittleGameInfo.ID);
			gSPacketIn.WriteInt(1);
			gSPacketIn.WriteString(property);
			if (property == "lock")
			{
				gSPacketIn.WriteInt(2);
				gSPacketIn.WriteBoolean(bool.Parse(value));
			}
			SendToAll(gSPacketIn);
        }

        public void SendRemoveLivingToAll(GamePlayer player)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166, player.PlayerCharacter.ID);
			gSPacketIn.WriteByte(17);
			gSPacketIn.WriteInt(player.LittleGameInfo.ID);
			SendToAll(gSPacketIn);
        }

        public void SendRemoveLivingToAll(Bogu bogu)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166);
			gSPacketIn.WriteByte(17);
			gSPacketIn.WriteInt(bogu.ID);
			SendToAll(gSPacketIn);
        }

        public void SendToAll(GSPacketIn gSPacketIn, GamePlayer player = null)
        {
			lock (LittleGameWorldMgr.ScenariObjects)
			{
				foreach (object value in LittleGameWorldMgr.ScenariObjects.Values)
				{
					GamePlayer gamePlayer = value as GamePlayer;
					if (gamePlayer != null && (player == null || (player != null && gamePlayer.LittleGameInfo.ID != player.LittleGameInfo.ID)))
					{
						gamePlayer.SendTCP(gSPacketIn);
					}
				}
			}
        }

        public void SendRemoveObject(GamePlayer player)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166);
			gSPacketIn.WriteByte(65);
			gSPacketIn.WriteInt(99);
			player.Out.SendTCP(gSPacketIn);
        }

        public void SendAddObject(GamePlayer player, Bogu bogu, string obj)
        {
			GSPacketIn gSPacketIn = new GSPacketIn(166);
			gSPacketIn.WriteByte(64);
			gSPacketIn.WriteString(obj);
			switch (obj)
			{
			case "bigbogu":
			case "normalbogu":
				gSPacketIn.WriteInt(1);
				gSPacketIn.WriteInt(player.LittleGameInfo.ID);
				gSPacketIn.WriteInt(bogu.ID);
				gSPacketIn.WriteInt(bogu.HP);
				gSPacketIn.WriteInt(bogu.Score);
				gSPacketIn.WriteInt(bogu.Score / bogu.HP);
				gSPacketIn.WriteInt(10);
				gSPacketIn.WriteInt(bogu.Catchers.Count);
				foreach (GamePlayer catcher in bogu.Catchers)
				{
					gSPacketIn.WriteInt(catcher.LittleGameInfo.ID);
				}
				break;
			case "bogugiveup":
				gSPacketIn.WriteInt(99);
				gSPacketIn.WriteInt(bogu.ID);
				gSPacketIn.WriteInt(bogu.MaxCatchers);
				break;
			}
			player.Out.SendTCP(gSPacketIn);
        }
    }
}
