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
    public class WorldBatKing : ABrain
    {
        private int m_attackTurn = 0;
        
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
            if (Body.State == 10)
            {
                KillAttack(0, Game.Map.Info.ForegroundWidth + 1);
                return;
            }            
            if (m_attackTurn == 0)
            {
                AttackA();
                m_attackTurn++;
            }           
            else
            {
                AttackB(0, Game.Map.Info.ForegroundWidth + 1);
                m_attackTurn = 0;
            }           
        }
        private void KillAttack(int fx, int tx)
        {
            int index = Game.Random.Next(0, KillAttackChat.Length);
            Body.Say(KillAttackChat[index], 1, 1000);
            Body.CurrentDamagePlus = 100;
            Body.PlayMovie("beatB", 3000, 0);
            Body.RangeAttacking(fx, tx, "cry", 5000, null);
        }

        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        private void AttackA()
        {
            //Body.Direction = Game.FindlivingbyDir(Body);
            int disX = Game.Random.Next(173, 1439);
            int disY = Game.Random.Next(150, 700);
            Body.MoveTo(disX, disY, "fly", 3000, "", 12, new LivingCallBack(AllAttackA));
        }
        private void AllAttackA()
        {
            Player target = Game.FindRandomPlayer();
            Body.Direction = Game.FindlivingbyDir(Body);
            if (target != null)
            {
                Body.CurrentDamagePlus = 10;
                int index = Game.Random.Next(0, ShootChat.Length);
                Body.Say(ShootChat[index], 1, 0);
                Body.PlayMovie("beatA", 1700, 0);
                Body.RangeAttacking(0, Game.Map.Info.ForegroundWidth + 1, "cry", 4000, null);
            }
        }
        private void AttackB(int fx, int tx)
        {
            Player target = Game.FindRandomPlayer();
            Body.Direction = Game.FindlivingbyDir(Body);
            if (target != null)
            {
                Body.CurrentDamagePlus = 15;
                int index = Game.Random.Next(0, ShootChat.Length);
                Body.Say(ShootChat[index], 1, 0);
                Body.PlayMovie("beatB", 1900, 0);
                Body.RangeAttacking(fx, tx, "cry", 4000, null);
                Body.CallFuction(new LivingCallBack(GoMovie), 4000);
            }
        }

        private void GoMovie()
        {
            List<Player> targets = Game.GetAllFightPlayers();
            foreach (Player p in targets)
            {
                //moive = ((PVEGame)Game).Createlayer(p.X, p.Y, "moive", "asset.game.zero.294b", "out", 1, 0);
            }            
            Body.CallFuction(new LivingCallBack(ShowIn), 2000);
        }
        private void ShowIn()
        {
            //(Game as PVEGame).SendGameObjectFocus(1, "BatIn", 0, 4000);
            Body.PlayMovie("in", 100, 0);
            //Game.
        }
        public override void OnKillPlayerSay()
        {
            base.OnKillPlayerSay();
            int index = Game.Random.Next(0, KillPlayerChat.Length);
            Body.Say(KillPlayerChat[index], 1, 0, 2000);
        }
        
    }
}
