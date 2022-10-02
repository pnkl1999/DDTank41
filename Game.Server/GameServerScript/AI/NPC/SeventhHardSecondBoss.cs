using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Bussiness;
using Game.Logic.Effects;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class SeventhHardSecondBoss : ABrain
    {
        private int m_attackTurn = 0;

        private bool IsEixt = false;

        protected Player m_targer;

        private PhysicalObj moive;

        private PhysicalObj m_effect = null;

        #region NPC Nội dung của bài phát biểu.
        private static string[] AllAttackChat = new string[] { 
            "Cận thận cái đầu !!"
        };

        private static string[] ShootChat = new string[]{
             "Thịt đè người !",
                               
             "Cảm nhận sức mạnh của ta !"
        };

        private static string[] KillAttackChat = new string[]{
            "Đến nộp mạng à ?? Sức mạnh tối cao!!..."
        };

        #endregion

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();
            m_body.CurrentDamagePlus = 1;
            m_body.CurrentShootMinus = 1;
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }

        public override void OnStartAttacking()
        {
            base.OnStartAttacking();
            Body.Direction = Game.FindlivingbyDir(Body);
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 0 && player.X < 350)
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
                KillAttack(0, 350);
                return;
            }

            if (m_attackTurn == 0)
            {
                if (IsEixt)
                {
                    Game.RemovePhysicalObj(m_effect, true);
                    IsEixt = false;
                }
                AttackingB();//b
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                AttackingA();//a
                m_attackTurn++;
            }
            else if (m_attackTurn == 2)
            {
                AttackingC();//c
                m_attackTurn++;
            }
            else if (m_attackTurn == 3)
            {
                AttackingD();
                m_attackTurn++;
            }
            else if (m_attackTurn == 4)
            {
                AttackingD();
                m_attackTurn++;
            }
            else
            {
                AttackingC();
                m_attackTurn = 0;
            }
        }

        private void KillAttack(int fx, int tx)
        {
            int index = Game.Random.Next(0, KillAttackChat.Length);
            Body.Say(KillAttackChat[index], 1, 0);
            Body.PlayMovie("skill", 1900, 0);
            Body.RangeAttacking(0, 350, "cry", 4000, null);
            Body.CallFuction(new LivingCallBack(GoKillAttack), 4000);
        }

        private void GoKillAttack()
        {
            Body.CurrentDamagePlus *= 10;
            m_targer = Game.FindNearestPlayer(Body.X, Body.Y);
            m_effect = ((PVEGame)Game).CreatePhysicalObj(m_targer.X, m_targer.Y, "skill", "asset.game.seven.jinqucd", "1", 1, 0);
        }

        private void AttackingB()
        {
            Player target = Game.FindRandomPlayer();
            if (target != null)
            {
                Body.MoveTo(target.X - 150, target.Y, "run", 1000, "", 18, new LivingCallBack(NextAttackB));
            }
        }

        private void NextAttackB()
        {
            Body.CurrentDamagePlus = 0.5f;
            Body.Direction = Game.FindlivingbyDir(Body);
            //int index = Game.Random.Next(0, AllAttackChat.Length);
            //Body.Say(AllAttackChat[index], 1, 0);
            Body.PlayMovie("beatB", 500, 0);
            Body.RangeAttacking(Body.X, Body.X + 170, "cry", 2500, null);
            Body.CallFuction(new LivingCallBack(Comback), 3000);
        }

        private void Comback()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            Body.MoveTo(181, Body.Y, "run", 1000, "", 18, new LivingCallBack(ChangeDirection));
        }

        private void ChangeDirection()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
        }
        private void AttackingA()
        {
            Player target = Game.FindRandomPlayer();
            if (target != null)
                Body.MoveTo(target.X - 150, target.Y, "run", 1000, "", 18, new LivingCallBack(NextAttackA));

        }
        private void NextAttackA()
        {
            Body.CurrentDamagePlus = 0.5f;
            Body.Direction = Game.FindlivingbyDir(Body);
            //int index = Game.Random.Next(0, ShootChat.Length);
            //Body.Say(ShootChat[index], 1, 0);
            Body.PlayMovie("beatA", 500, 0);
            Body.RangeAttacking(Body.X, Body.X + 170, "cry", 2500, null);
            Body.CallFuction(new LivingCallBack(Comback), 3000);
        }
        private void AttackingC()
        {
            Player target = Game.FindRandomPlayer();

            if (target != null)
            {
                int mtX = target.X;

                if (Body.ShootPoint(mtX, target.Y, 83, 1000, 10000, 3, 1, 3300))
                {
                    Body.PlayMovie("beatC", 1500, 0);
                }

            }
        }
        private void AttackingD()
        {
            Body.MoveTo(1477, Body.Y, "run", 1000, "", 18, new LivingCallBack(PersonalAttack));
        }
        private void PersonalAttack()
        {
            Body.Direction = -Body.Direction;
            Body.PlayMovie("beatD", 500, 8100);
            Body.CallFuction(new LivingCallBack(GoMovie), 6100);
        }
        private void GoMovie()
        {
            Player target = Game.FindRandomPlayer();
            if (target != null)
            {
                int mtX = target.X;
                Body.RangeAttacking(mtX - 200, mtX + 200, "cry", 3000, null);
                moive = ((PVEGame)Game).Createlayer(mtX, target.Y, "moive", "asset.game.seven.choud", "out", 1, 0);
                Body.CallFuction(new LivingCallBack(GoAttacking), 3000);
            }
        }

        private void GoAttacking()
        {
            Player target = Game.FindRandomPlayer();
            if (!IsEixt && target != null)
            {
                m_effect = ((PVEGame)Game).CreatePhysicalObj(target.X, target.Y, "effect", "asset.game.seven.du", "1", 1, 0);
                IsEixt = true;
                List<Player> players = Game.GetAllLivingPlayers();
                foreach (Player player in players)
                {
                    int dis = 140;
                    if (player.X > target.X - dis && player.X < target.X + dis)
                    {
                        player.AddEffect(new ContinueReduceBlood(2, 900, player), 0);
                    }
                }
            }
            Body.CallFuction(new LivingCallBack(Comback), 1000);
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
