using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Bussiness;


namespace Game.Server.GameServerScript.AI.NPC
{
    public class ThirdTerrorLongNpcFirst : ABrain
    {
        private int m_attackTurn = 0;

        private int isSay = 0;

        protected Player m_targer;

        #region NPC 说话内容

        private static string[] KillPlayerChat = new string[]{
            LanguageMgr.GetTranslation("Anh em tiến lên !")
        };

        private static string[] ShootedChat = new string[]{
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg15"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg16")

        };

        private static string[] DiedChat = new string[]{
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg17")
        };

        #endregion

        public override void OnBeginSelfTurn()
        {
            base.OnBeginSelfTurn();
        }

        public override void OnBeginNewTurn()
        {
            base.OnBeginNewTurn();

            Body.CurrentDamagePlus = 1;
            Body.CurrentShootMinus = 1;

            isSay = 0;
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
                if (player.IsLiving && player.X > 1269 && player.X < Game.Map.Info.ForegroundWidth + 1)
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
                KillAttack();

                return;
            }

            if (m_attackTurn == 0)
            {
                if (((PVEGame)Game).GetLivedLivings().Count == 9)
                {
                    PersonalAttack();
                }
                else
                {
                    PersonalAttack();
                }
                m_attackTurn++;
            }
            else
            {
                PersonalAttack();
                m_attackTurn = 0;
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        private void KillAttack()
        {
            m_targer = Game.FindNearestPlayer(Body.X, Body.Y);
            Beat(m_targer);
        }

        private void Beat(Player player)
        {
            int dis = (int)player.Distance(Body.X, Body.Y);
            if (player.X > Body.X)
            {
                Body.MoveTo(Body.X + dis + 50, Body.Y, "walk", 1200, "", 4, new LivingCallBack(MoveBeat));
            }
            else
            {
                Body.MoveTo(Body.X - dis - 50, Body.Y, "walk", 1200, "", 4, new LivingCallBack(MoveBeat));
            }

        }

        private void MoveBeat()
        {
            Body.Beat(m_targer, "beatB", 100, 0, 500, 1, 1);
        }

        private void PersonalAttack()
        {
            int dis = Game.Random.Next(1200, 1550);
            Body.MoveTo(dis, Body.Y, "walk", 1000, "", 4, new LivingCallBack(NextAttack));
        }

        private void NextAttack()
        {
            Player target = Game.FindRandomPlayer();
            Body.Direction = Game.FindlivingbyDir(Body);


            if (target != null)
            {
                Body.CurrentDamagePlus = 1.8f;

                if (Body.ShootPoint(target.X, target.Y, 58, 1000, 10000, 1, 2.5f, 2550))
                {
                    Body.PlayMovie("beatA", 1700, 0);
                }
            }
        }


        public override void OnKillPlayerSay()
        {
            base.OnKillPlayerSay();
            int index = Game.Random.Next(0, KillPlayerChat.Length);
            Body.Say(KillPlayerChat[index], 1, 0, 2000);
        }

        public override void OnShootedSay()
        {
            int index = Game.Random.Next(0, ShootedChat.Length);
            if (isSay == 0 && Body.IsLiving == true)
            {
                Body.Say(ShootedChat[index], 1, 900, 0);
                isSay = 1;
            }

            if (!Body.IsLiving)
            {
                index = Game.Random.Next(0, DiedChat.Length);
                Body.Say(DiedChat[index], 1, 900 - 800, 2000);
            }
        }
    }
}
