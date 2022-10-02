using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class SixNormalFourBoss : ABrain
    {
        private int m_attackTurn = 0;
		
		private PhysicalObj m_front;

        private Player target;

        private bool haveShield;

        private SimpleNpc shieldNpc;

        // can setting
        private int m_bloodRecover = 2000;

        private int m_countBeatD = 3;

        private int m_npcShield = 6144;

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;
            if (haveShield == true && shieldNpc != null && shieldNpc.IsLiving == false)
            {
                // npc dead + have shield => remove all effect
                haveShield = false;
                Body.Config.IsShield = false;
                Game.RemoveLiving(shieldNpc.Id);
                (Game as PVEGame).SendLivingActionMapping(Body, "shield", "shield");
                (Game as PVEGame).SendLivingActionMapping(Body, "stand", "stand");
                (Game as PVEGame).SendHideBlood(Body, 1);
            }
            else if (haveShield == true && shieldNpc != null && shieldNpc.IsLiving && (shieldNpc.X != Body.X || shieldNpc.Y != Body.Y))
            {
                shieldNpc.BoltMove(Body.X, Body.Y, 0);
            }
        }

        public override void OnCreated()
        {
            base.OnCreated();
            haveShield = false;
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            Body.Direction = Game.FindlivingbyDir(Body);
            /*foreach (Player player in Game.GetAllFightPlayers())
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
            
            */
            /*if (result)
            {
                return;
            }*/
            if (m_attackTurn == 0)
            {
                BeatD();
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                BeatC();
                m_attackTurn++;
            }
			else if (m_attackTurn == 2)
            {
                BeatB();
                m_attackTurn++;
            }
			else if (m_attackTurn == 3)
            {
                if (haveShield == false)
                {
                    InX();
                }
                else
                {
                    BeatE();
                    m_attackTurn++;
                }
                m_attackTurn++;
            }
			else if (m_attackTurn == 4)
            {
                BeatE();
                m_attackTurn++;
            }
			else if (m_attackTurn == 5)
            {
                AddBlood();
                m_attackTurn++;
            }
            else
            {
                BeatA();
                m_attackTurn = 0;
            }
			//}
        }

        private void BeatB()
        {
			target = Game.FindRandomPlayer();
			if(Body.X > target.X)
			{
			    Body.MoveTo(target.X + 150, Body.Y, "walk", 1000, "", 5, new LivingCallBack(RBeatB)); 
			}
			else
			{
			    Body.MoveTo(target.X - 150, Body.Y, "walk", 1000, "", 5, new LivingCallBack(RBeatB)); 
			}

			if (target.X > Body.Y)
            {
                Body.ChangeDirection(1, 1200);
            }
            else
            {
                Body.ChangeDirection(-1, 1200);
            }
        }
		
		private void RBeatB()
        {
			Body.CurrentDamagePlus = 1.5f;
            Body.PlayMovie("beatB", 1500, 0);
            Body.BeatDirect(target, "", 4000, 3, 1);
        }
		
		private void BeatC()
        {
            Body.CurrentDamagePlus = 2f;
            Body.PlayMovie("beatC", 1500, 0);
            Body.RangeAttacking(Body.X - 1000, Body.X + 1000, "cry", 3000, null);
        }
		
		private void BeatD()
        {
            target = Game.FindRandomPlayer();
			Body.CurrentDamagePlus = 2.5f;
            Body.PlayMovie("beatD", 1000, 3000);
			Body.JumpTo(target.X, Body.Y - 475, "", 1500, 0, 5, new LivingCallBack(GBeatD), 1);
        }
		
		private void GBeatD()
        {
            Body.BeatDirect(target, "", 4000, m_countBeatD, 1);
		    //Body.RangeAttacking(Body.X - 300, Body.X + 300, "cry", 4000, null);
		}
		
		private void BeatE()
        {
            Body.PlayMovie("beatE", 3000, 0);
			Body.CallFuction(new LivingCallBack(RBeatE), 3200);
        }
		
		private void RBeatE()
        {
		    Body.PlayMovie("stand", 8500, 1000);
			m_front = ((PVEGame)Game).CreateLayerBoss(Body.X - 500, 550, "front", "asset.game.six.chang", "in", 1, 0);
			((PVEGame)Game).SendGameFocus(1250, 450, 1, 0, 4000);
			Body.CurrentDamagePlus = 3f;
			Body.RangeAttacking(Body.X - 3000, Body.X + 3000, "cry", 7000, null);
        }
		
        private void BeatA()
        {
            int dis = Game.Random.Next(900, 1400);
            Body.MoveTo(dis, Body.Y, "walk", 1000, "", 4, new LivingCallBack(NextAttack));
        }

        private void NextAttack()
        {
            Player target = Game.FindRandomPlayer();

            if (target.X > Body.Y)
            {
                Body.ChangeDirection(1, 800);
            }
            else
            {
                Body.ChangeDirection(-1, 800);
            }

            Body.CurrentDamagePlus = 2.8f;

            if (target != null)
            {
                //int mtX = Game.Random.Next(target.X - 50, target.X + 50);

                if (Body.ShootPoint(target.X, target.Y, 61, 1000, 10000, 1, 3f, 2300))
                {
                    Body.PlayMovie("beatA", 1500, 0);
                }

                if (Body.ShootPoint(target.X, target.Y, 61, 1000, 10000, 1, 3f, 4100))
                {
                    Body.PlayMovie("beatA", 3300, 0);
                }
            }
        }
		
		
		private void AddBlood()
        {
            //m_front = ((PVEGame)Game).Createlayerboss(Body.X, Body.Y, "font", "asset.game.six.popcan", "green", 1, 0);
			Body.CallFuction(new LivingCallBack(Blood), 2000);
        }
		
		private void Blood()
        {
			Body.SyncAtTime = true;
			Body.PlayMovie("shieldB", 0, 2500);
			Body.AddBlood(m_bloodRecover);
        }
		
		private void InX()
        {
            Body.SyncAtTime = true;
			Body.PlayMovie("inX", 0, 4500);
            Body.CallFuction(new LivingCallBack(MakeShield), 5000);
			//Body.AddBlood(m_bloodRecover);
        }

        private void MakeShield()
        {
            LivingConfig config = (Game as PVEGame).BaseConfig();
            //config.IsFly = true;
            shieldNpc = (Game as PVEGame).CreateNpc(m_npcShield, Body.X, Body.Y, 1, Body.Direction, config);

            haveShield = true;
            Body.Config.IsShield = true;
            (Game as PVEGame).SendLivingActionMapping(Body, "shield", "shieldB");
            (Game as PVEGame).SendLivingActionMapping(Body, "stand", "standC");
            (Game as PVEGame).SendHideBlood(Body, 0);
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
