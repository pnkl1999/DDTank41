using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class ConsortiaScorpionBoss : ABrain
    {
        private int m_attackTurn = 0;

        public int currentCount = 0;

        public int Dander = 0;

        private PhysicalObj moive;

        Player target = null;

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();

            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;
            Body.SetRect(((SimpleBoss)Body).NpcInfo.X, ((SimpleBoss)Body).NpcInfo.Y, ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Height);

            if (Body.Direction == -1)
            {
                Body.SetRect(((SimpleBoss)Body).NpcInfo.X, ((SimpleBoss)Body).NpcInfo.Y, ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Height);
            }
            else
            {
                Body.SetRect(-((SimpleBoss)Body).NpcInfo.X - ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Y, ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Height);
            }

        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 857 && player.X < 1440)
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
                KillAttack(0, Game.Map.Info.ForegroundWidth + 1);

                return;
            }

            if (m_attackTurn == 0)
            {
                Moving();
                m_attackTurn++;
            }            
            else
            {
                AllAttack();
                m_attackTurn = 0;
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
        private void KillAttack(int fx, int tx)
        {
            ChangeDirection(3);
            Body.PlayMovie("beatA", 1000, 0);
            target = Game.FindRandomPlayer();
            if (target == null)
                return;
            Body.CurrentDamagePlus = 308f;
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 3300, null);
            Body.CallFuction(CreateEffect, 3300);
            Body.CallFuction(Out, 4600);
        }
        private void AllAttack()
        {
            ChangeDirection(3);
            Body.PlayMovie("beatA", 1000, 0);
            target = Game.FindRandomPlayer();
            if (target != null)
                return;
            Body.CurrentDamagePlus = 3.8f;
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 3300, null);
            Body.CallFuction(CreateEffect, 3300);
            Body.CallFuction(Out, 4600);
        }
        public void CreateEffect()
        {
            if (target != null)
            {                
                if (target.X < 1000)
                {
                    moive = ((PVEGame)Game).Createlayer(target.X, target.Y, "effect", "asset.game.eight.xiezi", "beatA", 1, 0);
                }
                else
                {
                    moive = ((PVEGame)Game).Createlayer(target.X, target.Y, "effect", "asset.game.eight.xiezi", "beatB", 1, 0);
                }
            }
        }       

        private void Out()
        {
            ((PVEGame)Game).SendGameFocus(Body, 1000, 2000);
            Body.PlayMovie("in", 1000, 0);
            if (moive != null)
            {
                Game.RemovePhysicalObj(moive, true);
                moive = null;
            }
            
        }
        private void Moving()
        {
            ChangeDirection(3);
            int dis = Game.Random.Next(990, 1300);
            int direction = Body.Direction;
            Body.MoveTo(dis, Body.Y, "walk", 1000, ((SimpleBoss)Body).NpcInfo.speed);
            Body.ChangeDirection(Game.FindlivingbyDir(Body), 3000);
        } 
        private void ChangeDirection(int count)
        {
            int direction = Body.Direction;
            for (int i = 0; i < count; i++)
            {
                Body.ChangeDirection(-direction, i * 200 + 100);
                Body.ChangeDirection(direction, (i + 1) * 100 + i * 200);
            }
        }
    }
}
