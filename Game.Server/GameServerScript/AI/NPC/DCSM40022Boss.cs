using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Game.Logic.Actions;
using Bussiness;
using Game.Server.Rooms;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class DCSM40022Boss : ABrain
    {
        private int m_attackTurn = 0;

        private Point[] brithPoint = { new Point(979, 630), new Point(1013, 630), new Point(1052, 630), new Point(1088, 630), new Point(1142, 630) };

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[] {
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg1"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg2"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg3")
        };

        private static string[] ShootChat = new string[]{
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg4"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg5")  
        };

        private static string[] KillPlayerChat = new string[]{
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg6"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg7")
        };

        private static string[] CallChat = new string[]{
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg8"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg9")

        };

        private static string[] JumpChat = new string[]{
             LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg10"),

             LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg11"),

             LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.SimpleQueenAntAi.msg12")
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
                if (player.IsLiving && player.X > 1000)
                {
                    int dis = (int)Body.Distance(player.X, player.Y);
                    if (dis > maxdis)
                    {
                        maxdis = dis;
                    }
                    result = true;
                }
            }
            //if (result)
            //{
            //    KillAttack(0, Game.Map.Info.ForegroundWidth + 1);
            //    return;
            //}

            if (m_attackTurn == 0)
            {
                PersonalAttackC();
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                PersonalAttackE();
                m_attackTurn++;
            }
            else
            {
                KillAttack();
                m_attackTurn = 0;
            }
        }
        private void KillAttack(int fx, int tx)
        {
            int index = Game.Random.Next(0, KillAttackChat.Length);
            Body.Say(KillAttackChat[index], 1, 1000);
            Body.CurrentDamagePlus = 100;
            Body.PlayMovie("beatF", 3000, 0);
            Body.RangeAttacking(fx, tx, "cry", 5000, null);
        }
        
        private void KillAttack()
        {
            Player target = Game.FindRandomPlayer();

            if (target != null)
            {
                int index = Game.Random.Next(0, KillAttackChat.Length);
                Body.Say(KillAttackChat[index], 1, 1000);
                Body.CurrentDamagePlus = 15;
                Body.PlayMovie("beatF", 3000, 0);
                Body.RangeAttacking(0, Body.X + 1000, "cry", 5000, null);
            }
            
        }

        private void PersonalAttackC()
        {
            Player target = Game.FindRandomPlayer();

            if (target != null)
            {
                Body.CurrentDamagePlus = 5;
                int index = Game.Random.Next(0, ShootChat.Length);
                Body.Say(ShootChat[index], 1, 0);
                int dis = Game.Random.Next(0, 1200);
                Body.PlayMovie("beatC", 1700, 0);
                Body.RangeAttacking(0, Body.X + 1000, "cry", 4000, null);
                
            }
        }

        private void PersonalAttackE()
        {
            Player target = Game.FindRandomPlayer();

            if (target != null)
            {
                Body.CurrentDamagePlus = 10;
                int index = Game.Random.Next(0, ShootChat.Length);
                Body.Say(ShootChat[index], 1, 0);
                int dis = Game.Random.Next(0, 1200);
                Body.PlayMovie("beatE", 1700, 0);
                Body.RangeAttacking(0, Body.X + 1000, "cry", 4000, null);

            }
        }
       
    }
}
