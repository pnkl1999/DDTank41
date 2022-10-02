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
    public class ThirdNormalLongNpcSecond : ABrain
    {
        private int m_attackTurn = 0;

        private int isSay = 0;

        #region NPC 说话内容
        private static string[] KillPlayerChat = new string[]{
            LanguageMgr.GetTranslation("Anh em tiến lên !")
        };

        private static string[] KillAttackChat = new string[]{
             LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg13"),

              LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg14")
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
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > Body.X - 300 && player.X < Body.X + 300)
                {
                    result = true;
                }
            }

            if (result)
            {
                KillAttack(Body.X - 300, Body.X + 300);

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

        private void KillAttack(int fx, int tx)
        {
            int index = Game.Random.Next(0, KillAttackChat.Length);
            Body.Say(KillAttackChat[index], 1, 1000);
            Body.CurrentDamagePlus = 100f;
            Body.PlayMovie("beatB", 3000, 0);
            Body.RangeAttacking(fx, tx, "cry", 5000, null);
        }
		
		private void PersonalAttack()
        {
            int dis = Game.Random.Next(50, 200);
            Body.MoveTo(dis, Body.Y, "walk", 1000, "", 4, new LivingCallBack(NextAttack));
        }

        private void NextAttack()
        {
            Player target = Game.FindRandomPlayer();

            if (target != null)
            {
                Body.CurrentDamagePlus = 1.8f;
				if (target.X > Body.Y)
                {
                Body.ChangeDirection(1, 50);
                }
                else
                {
                Body.ChangeDirection(-1, 50);
                }

                int mtX = Game.Random.Next(target.X - 0, target.X + 0);

                if (Body.ShootPoint(1100, target.Y, 58, 1000, 10000, 3, 3.0f, 2550))
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
