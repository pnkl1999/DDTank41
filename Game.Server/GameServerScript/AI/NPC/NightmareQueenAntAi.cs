using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic.Phy.Object;
using Game.Logic;
using System.Drawing;
using Bussiness;


namespace Game.Server.GameServerScript.AI.NPC
{
    public class NightmareQueenAntAi : ABrain
    {
        private int m_attackTurn = 0;

        private int npcID = 2404;

        private int isSay = 0;

        private Point[] brithPoint = { new Point(979, 630), new Point(1013, 630), new Point(1052, 630), new Point(1088, 630), new Point(1142, 630) };

        #region NPC 说话内容
        private static string[] AllAttackChat = new string[] {
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg1"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg2"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg3")
        };

        private static string[] ShootChat = new string[]{
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg4"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg5")  
        };

        private static string[] KillPlayerChat = new string[]{
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg6"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg7")
        };

        private static string[] CallChat = new string[]{
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg8"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg9")

        };

        private static string[] JumpChat = new string[]{
             LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg10"),

             LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg11"),

             LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg12")
        };

        private static string[] KillAttackChat = new string[]{
             LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg13"),

              LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg14")
        };

        private static string[] ShootedChat = new string[]{
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg15"),

            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg16")

        };

        private static string[] DiedChat = new string[]{
            LanguageMgr.GetTranslation("Game.Server.GameServerScript.AI.NPC.NormalQueenAntAi.msg17")
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
                if (player.IsLiving && player.X > 1169 && player.X < Game.Map.Info.ForegroundWidth + 1)
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
                KillAttack(1169, Game.Map.Info.ForegroundWidth + 1);

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
                    Summon();
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
            Body.CurrentDamagePlus = 10;
            Body.PlayMovie("beatB", 3000, 0);
            Body.RangeAttacking(fx, tx, "cry", 5000, null);
        }

        private void PersonalAttack()
        {
            Player target = Game.FindRandomPlayer();


            if (target != null)
            {
                Body.CurrentDamagePlus = 0.8f;
                int index = Game.Random.Next(0, ShootChat.Length);
                Body.Say(ShootChat[index], 1, 0);
                int dis = Game.Random.Next(670, 880);


                //int mtX = Game.Random.Next(target.X - 10, target.X + 10);

                if (Body.ShootPoint(target.X, target.Y, ((SimpleBoss)Body).NpcInfo.CurrentBallId, 1000, 10000, 1, 3.0f, 2550))
                {
                    Body.PlayMovie("beatA", 1700, 0);
                }
            }
        }

        private void Summon()
        {
            int index = Game.Random.Next(0, CallChat.Length);
            Body.Say(CallChat[index], 1, 600);
            Body.PlayMovie("call", 1700, 2000);
            Body.CallFuction(new LivingCallBack(Call),2000);
        }

        private void Call()
        {
            ((SimpleBoss)Body).CreateChild(npcID, brithPoint, 9, 3,9,-1);
        }        

        public  void OnShootedSay(int delay)
        {
            int index = Game.Random.Next(0, ShootedChat.Length);
            if (isSay == 0 && Body.IsLiving == true)
            {                
                Body.Say(ShootedChat[index], 1, delay, 0);
                isSay = 1;
            }

            if (!Body.IsLiving)
            {
                index = Game.Random.Next(0, DiedChat.Length);
                Body.Say(DiedChat[index], 1, delay - 800, 2000);
            }
        }
    }
}
