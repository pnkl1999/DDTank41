using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using Bussiness;
namespace Game.Server.GameServerScript.AI.NPC
{
    public class WorldCupBossFor14209 : ABrain
    {
        private int m_attackTurn = 0;
        private int isSay = 0;
        private PhysicalObj moive;

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

            isSay = 0;
        }

        public override void OnCreated()
        {
            base.OnCreated();
        }
        private int npcID = 14208;        
        private SimpleNpc arbiNpc = null;
        public override void OnStartAttacking()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 1155 && player.X < 1571)
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
            if (!Body.Config.IsShield && Body.Blood > 1)
            {
                return;
            }
            arbiNpc = Game.FindHelper();
            if (m_attackTurn == 0)
            {
                AttackB(0, Game.Map.Info.ForegroundWidth + 1);
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                AttackA(0, Game.Map.Info.ForegroundWidth + 1);
                m_attackTurn++;
            }
            else if (m_attackTurn == 2)
            {
                AttackC(0, Game.Map.Info.ForegroundWidth + 1);
                m_attackTurn++;
            }
            else if (m_attackTurn == 3)
            {
                GoOutGoal();
                m_attackTurn++;
            }
            else
            {
                ComeBackGoal();
                m_attackTurn = 0;
            }
        }
        private void GoOutGoal()
        {
            Body.MoveTo(1152, 861, "walk", 1000, "", 3, OnDown);
        }
        private void OnDown()
        {
            ((PVEGame)Game).SendGameFocus(Body, 0, 2000);
            Body.SetRelateDemagemRect(-15, -35, 35, 35);
            Body.PlayMovie("cryB", 2000, 0);
            ((SimpleBoss)Body).AddDelay(1000);
            //((SimpleBoss)Body).State = 1;
            Body.Config.IsDown = true;
        }
        private void ComeBackGoal()
        {
            //((SimpleBoss)Body).State = 0;
            Body.Config.IsDown = false;
            Body.MoveTo(1223, 861, "walk", 1000, "", 3, OnUp);
        }
        private void OnUp()
        {
            Body.Direction = Game.FindlivingbyDir(Body);
            Body.PlayMovie("standB", 2000, 0);
            Body.AddBlood(((SimpleBoss)Body).NpcInfo.Blood);
            Body.Config.IsShield = true;
            ((PVEGame)Game).CanBeginNextProtect = true;
            Body.Config.IsDown = false;
            Body.SetRelateDemagemRect(((SimpleBoss)Body).NpcInfo.X, ((SimpleBoss)Body).NpcInfo.Y, ((SimpleBoss)Body).NpcInfo.Width, ((SimpleBoss)Body).NpcInfo.Height);
        }
        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }

        private void KillAttack(int fx, int tx)
        {
            int index = Game.Random.Next(0, KillAttackChat.Length);
            Body.Say(KillAttackChat[index], 1, 1000);
            Body.CurrentDamagePlus = 100;
            Body.PlayMovie("beatD", 3000, 0);
            Body.RangeAttacking(fx, tx, "cry", 5000, null);
        }

        private void AttackA(int fx, int tx)
        {
            Player target = Game.FindRandomPlayer();
            if (target != null)
            {
                Body.CurrentDamagePlus = 1.7f;
                int index = Game.Random.Next(0, ShootChat.Length);
                Body.Say(ShootChat[index], 1, 0);
                int dis = Game.Random.Next(0, 1200);
                Body.PlayMovie("beatA", 1700, 0);
                Body.RangeAttacking(fx, tx, "cry", 4000, null);
            }
        }
        private void AttackB(int fx, int tx)
        {
            Player target = Game.FindRandomPlayer();
            if (target != null)
            {
                Body.CurrentDamagePlus = 2.1f;
                int index = Game.Random.Next(0, ShootChat.Length);
                Body.Say(ShootChat[index], 1, 0);
                int dis = Game.Random.Next(0, 1200);
                Body.PlayMovie("beatB", 1900, 0);
                Body.RangeAttacking(fx, tx, "cry", 4000, null);
                Body.CallFuction(GoMovie, 4000);
            }
        }

        private void GoMovie()
        {
            List<Player> targets = Game.GetAllFightPlayers();
            foreach (Player p in targets)
            {
                moive = ((PVEGame)Game).Createlayer(p.X, p.Y, "moive", "asset.game.zero.294b", "out", 1, 0);
            }
        }
        private void AttackC(int fx, int tx)
        {
            if (arbiNpc == null)
                return;
            Body.CurrentDamagePlus = 200f;            
            Body.PlayMovie("beatE", 1300, 0);
            Body.CallFuction(RangeAttackingNPC, 2000);
        }
        private void RangeAttackingNPC()
        {
            List<Living> npcs = Game.FindLivingByID(npcID);
            Body.RangeAttackingNPC("movie", 2000, npcs);
            ((PVEGame)Game).SendGameFocus(arbiNpc, 0, 1000);
            if (((PVEGame)Game).TotalKillCount > npcs.Count)
            {
                Body.CallFuction(CallYellowCard, 3200);
            }
            else
            {
                Body.CallFuction(CallRedCard, 3200); 
            }
            
        }
        private void CallYellowCard()
        {
            ((PVEGame)Game).SendGameFocus(arbiNpc, 0, 1000);
            arbiNpc.PlayMovie("beatA", 2000, 0);
            arbiNpc.CallFuction(RemoveProtect, 2200);            
        }
        private void CallRedCard()
        {
            ((PVEGame)Game).SendGameFocus(Body, 0, 2000);
            Body.Say("Bye nhóc thua rồi nhé.", 1, 0, 2000);
            arbiNpc.CallFuction(EndGame, 2200);           
        }
        private void EndGame()
        {
            ((PVEGame)Game).SendGameFocus(arbiNpc, 0, 170);
            arbiNpc.PlayMovie("beatC", 1700, 0);
            arbiNpc.Say("Quá kém cỏi, thẻ đỏ rời sân ngay.", 1, 0, 2000);
            ((PVEGame)Game).IsMissBall = true;
        }
        private void RemoveProtect()
        {
            ((PVEGame)Game).SendGameFocus(Body, 0, 1700);
            Body.PlayMovie("beatD", 1700, 0);
            Body.Config.IsShield = false;
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
