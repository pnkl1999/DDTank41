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
    public class SeventhHardLongNpc : ABrain
    {
        private int m_attackTurn = 0;
		
		private PhysicalObj moive;

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[] {
            LanguageMgr.GetTranslation("Ddtank super là số 1"),
        };

        private static string[] ShootChat = new string[]{
            LanguageMgr.GetTranslation("Anh em tiến lên !"),
        };

        private static string[] KillPlayerChat = new string[]{
            LanguageMgr.GetTranslation("Anh em tiến lên !")
        };

        private static string[] CallChat = new string[]{
            LanguageMgr.GetTranslation("Ai giết được chúng sẻ được ban thưởng !"),

        };

        private static string[] JumpChat = new string[]{
             LanguageMgr.GetTranslation("Ai giết được chúng sẻ được ban thưởng !"),

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
                if (player.IsLiving && player.X < 870)
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
                KillAttack(0, Body.X + 100);
                return;
            }

            if (m_attackTurn == 0)
            {
                AllAttack();
                m_attackTurn++;
            }
            else
            {
                Move();
                m_attackTurn = 0;
            }
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
        public void Move()
        {
            int disX = Game.Random.Next(600, 750);
            Body.MoveTo(disX, Body.Y, "walk", 1200, 3);
        }
        private void KillAttack(int fx, int tx)
        {
            Body.CurrentDamagePlus = 1;
            Body.PlayMovie("beatB", 2000, 0);
            Body.RangeAttacking(fx, tx, "cry", 3000, null);
        }

        private void AllAttack()
        {
            Body.PlayMovie("beatB", 3000, 0);
            Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 6000, null);
            Body.CallFuction(new LivingCallBack(GoMovie), 5000);
        }
        private void GoMovie()
        {
            List<Player> targets = Game.GetAllFightPlayers();
            foreach (Player p in targets)
            {
                moive = ((PVEGame)Game).Createlayer(p.X, p.Y, "moive", "asset.game.seven.cao", "out", 1, 0);
                moive.PlayMovie("in", 1000, 0);
            }
        }
    }
}
