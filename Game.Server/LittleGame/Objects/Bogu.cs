using Bussiness;
using System.Collections.Generic;
using System.Drawing;
using System.Threading;

namespace Game.Server.LittleGame.Objects
{
    public class Bogu
    {
        public int X;

        public int Y;

        public int ID;

        public object Locker = new
		{

		};

        public readonly string Model;

        public bool IsBack = false;

        public string Direction = "";

        public int Size;

        private bool сaught;

        private readonly LittleGamePacketsOut Out = new LittleGamePacketsOut();

        private Timer m_moverTimer;

        private Timer m_catchingTimer;

        private string m_action = "";

        public int MaxCatchers = 1;

        public List<GamePlayer> Catchers = new List<GamePlayer>();

        public int Score { get; }

        public int HP { get; }

        public bool Сaught
        {
			get
			{
				return сaught;
			}
			set
			{
				сaught = value;
				if (value)
				{
					Action = "livingInhale";
					if (Size < 2)
					{
						m_catchingTimer = new Timer(Escaping, null, 10000, 0);
					}
				}
			}
        }

        public string Action
        {
			get
			{
				return m_action;
			}
			set
			{
				m_action = value;
				if (!(value == ""))
				{
					LittleGameWorldMgr.Out.SendActionToAll(this, value);
				}
			}
        }

        private void Escaping(object state)
        {
			Сaught = false;
			Action = "livingUnInhale";
			foreach (GamePlayer catcher in Catchers)
			{
				catcher.LittleGameInfo.Actions.Enqueue("livingUnInhale");
			}
			Catchers.Clear();
			RandomMove(null);
			Action = "";
			m_catchingTimer.Dispose();
        }

        public Bogu(int id, int x, int y, string model, int size)
        {
			ID = id;
			X = x;
			Y = y;
			Model = model;
			Size = size;
			switch (size)
			{
			case 0:
				m_moverTimer = new Timer(RandomMove, null, 3000 + ThreadSafeRandom.NextStatic(100, 500), 4555 + ThreadSafeRandom.NextStatic(1000, 1500));
				Score = LittleGameWorldMgr.Config.SmallBoguScore;
				HP = LittleGameWorldMgr.Config.SmallBoguHP;
				break;
			case 1:
				m_moverTimer = new Timer(RandomMove, null, 3000 + ThreadSafeRandom.NextStatic(100, 500), 4555 + ThreadSafeRandom.NextStatic(2500, 3500));
				Score = LittleGameWorldMgr.Config.MediumBoguScore;
				HP = LittleGameWorldMgr.Config.MediumBoguHP;
				break;
			case 2:
				m_moverTimer = new Timer(RandomMove, null, 3000 + ThreadSafeRandom.NextStatic(100, 500), 4555 + ThreadSafeRandom.NextStatic(4500, 5500));
				Score = LittleGameWorldMgr.Config.BigBoguScore;
				HP = LittleGameWorldMgr.Config.BigBoguHP;
				MaxCatchers = LittleGameWorldMgr.Config.BigBoguCatchers;
				break;
			case 3:
				m_moverTimer = new Timer(RandomMove, null, 3000 + ThreadSafeRandom.NextStatic(100, 500), 4555 + ThreadSafeRandom.NextStatic(6500, 8500));
				Score = LittleGameWorldMgr.Config.HugeBoguScore;
				HP = LittleGameWorldMgr.Config.HugeBoguHP;
				MaxCatchers = LittleGameWorldMgr.Config.HugeBoguCatchers;
				break;
			}
        }

        private void RandomMove(object state)
        {
			if (LittleGameWorldMgr.PlayerCount != 0 && !Сaught)
			{
				Point point = LittleGameWorldMgr.Map.points[ThreadSafeRandom.NextStatic(LittleGameWorldMgr.Map.points.Count - 1)];
				X = point.X;
				Y = point.Y;
				Out.SendMoveToAll(this);
			}
        }
    }
}
