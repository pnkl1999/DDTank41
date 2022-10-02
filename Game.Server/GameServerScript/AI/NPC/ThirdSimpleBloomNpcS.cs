using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdSimpleBloomNpcS : ABrain
    {
        private Player m_target= null;

        private int m_targetDis = 0;
		
		private int attackingTurn = 1;
		
		private int IsEixt = 0;
		
        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;

        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            bool result = false;
            int maxdis = 0;
			Body.Direction = Game.FindlivingbyDir(Body);
			m_target = Game.FindNearestPlayer(Body.X, Body.Y);
            m_targetDis = (int)m_target.Distance(Body.X, Body.Y);
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 0 && player.X < 0)
                {
                    int dis = (int)Body.Distance(player.X, player.Y);
                    if (dis > maxdis)
                    {
                        maxdis = dis;
                    }
                    result = true;
                }
            }

            if (result)
            {
                KillAttack(0, 0);
                return;
            }

            if (result == true)
            {
                return;
            }

            if (attackingTurn == 1)
            {
				if (m_targetDis < 100)
                {
                    List<Player> players = Game.GetAllLivingPlayers();
			        foreach (Player player in players)
                    {
                        player.AddBlood(700);
                    }
				    Body.PlayMovie("renew", 700, 400);
                } 
                else
                {
                    MoveToPlayer(m_target);
                }
            }
            else if (attackingTurn == 2)
            {
                if (m_targetDis < 100)
                {
                    List<Player> players = Game.GetAllLivingPlayers();
			        foreach (Player player in players)
                    {
                        player.AddBlood(700);
                    }
				    Body.PlayMovie("renew", 700, 400);
                } 
                else
                {
                    MoveToPlayer(m_target);
                }
            }
            else if (attackingTurn == 3)
            {
                if (m_targetDis < 100)
                {
                    List<Player> players = Game.GetAllLivingPlayers();
			        foreach (Player player in players)
                    {
                        player.AddBlood(700);
                    }
				    Body.PlayMovie("renew", 700, 400);
                } 
                else
                {
                    MoveToPlayer(m_target);
                }
            }
			else if (attackingTurn == 4)
            {
                if (m_targetDis < 100)
                {
                    List<Player> players = Game.GetAllLivingPlayers();
			        foreach (Player player in players)
                    {
                        player.AddBlood(700);
                    }
				    Body.PlayMovie("renew", 700, 400);
                } 
                else
                {
                    MoveToPlayer(m_target);
                }
            }
			else if (attackingTurn == 5)
            {
			    Body.PlayMovie("die", 700, 400);
			    Body.CallFuction(new LivingCallBack(MoveTo), 1500);				
            }
            else
            {
                
                attackingTurn = 1;
            }
            attackingTurn++;
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
		
		public void KillAttack(int fx, int mx)
        {
		}

        public void MoveToPlayer(Player player)
        {
            Body.Say("Đến gần tui sẻ hồi máu cho!", 0, 2000);
        }
		
		public void MoveTo()
        {
			if (IsEixt == 1)
			{
			    Body.JumpToSpeed(478, 560, "born", 0, 0, 36, null);
				IsEixt = 0;
			}
			else
			{
			    Body.JumpToSpeed(1000, 560, "born", 0, 0, 36, null);
				IsEixt = 1;
			}
        }

        public void Beat()
        {
            if (m_targetDis < 100)
            {
                List<Player> players = Game.GetAllLivingPlayers();
			    foreach (Player player in players)
                {
                    player.AddBlood(700);
   
                }
				Body.PlayMovie("renew", 700, 400);

            }
        }
    }
}
