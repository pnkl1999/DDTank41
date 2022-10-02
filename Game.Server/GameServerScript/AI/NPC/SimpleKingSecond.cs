using System;
using System.Collections.Generic;
using System.Text;
using Game.Logic.AI;
using Game.Logic;
using Game.Logic.Phy.Object;

namespace Game.Server.GameServerScript.AI.NPC
{
    public class SimpleKingSecond : ABrain
    {
        private int m_attackTurn = 0;

        private int m_turn = 0;

        private PhysicalObj m_wallLeft = null;

        private PhysicalObj m_wallRight = null;

        private int IsEixt = 0;
        #region NPC 说话内容
        private static string[] AllAttackChat = new string[] { 
             "要地震喽！！<br/>各位请扶好哦",
       
             "把你武器震下来！",
       
             "看你们能还经得起几下！！"
        };

        private static string[] ShootChat = new string[]{
             "让你知道什么叫百发百中！",
                               
             "送你一个球~你可要接好啦",

             "你们这群无知的低等庶民"
        };

        private static string[] ShootedChat = new string[]{
           "哎呀~~你们为什么要攻击我？<br/>我在干什么？",
                   
            "噢~~好痛!我为什么要战斗？<br/>我必须战斗…"

        };

        private static string[] KillPlayerChat = new string[]{
             "马迪亚斯不要再控制我！",       

             "这就是挑战我的下场！",

             "不！！这不是我的意愿… " 
        };

        private static string[] AddBooldChat = new string[]{
            "扭啊扭~<br/>扭啊扭~~",
               
            "哈利路亚~<br/>路亚路亚~~",
                
            "呀呀呀，<br/>好舒服啊！"
         
        };

        private static string[] KillAttackChat = new string[]{
            "君临天下！！"
        };

        private static string[] FrostChat = new string[]{
            "来尝尝这个吧",
               
            "让你冷静一下",
               
            "你们激怒了我"
              
        };

        private static string[] WallChat = new string[]{
             "神啊，赐予我力量吧！",

             "绝望吧，看我的水晶防护墙！"
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
            bool result = false;
            int maxdis = 0;
            foreach (Player player in Game.GetAllFightPlayers())
            {
                if (player.IsLiving && player.X > 390 && player.X < 1110)
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
                KillAttack(390, 1110);
                return;
            }

            if (m_attackTurn == 0)
            {
                AllAttack();
                if (IsEixt == 1)
                {
                    m_wallLeft.CanPenetrate = true;
                    m_wallRight.CanPenetrate = true;
                    Game.RemovePhysicalObj(m_wallLeft, true);
                    Game.RemovePhysicalObj(m_wallRight, true);
                    IsEixt = 0;
                }
                m_attackTurn++;
            }
            else if (m_attackTurn == 1)
            {
                FrostAttack();
                m_attackTurn++;
            }
            else if (m_attackTurn == 2)
            {
                ProtectingWall();
                m_attackTurn++;
            }
            else
            {

                CriticalStrikes();
                m_attackTurn = 0;
            }
        }

        private void CriticalStrikes()
        {
            Player target = Game.GetFrostPlayerRadom();
            List<Player> players = Game.GetAllFightPlayers();
            List<Player> NotFrostPlayers = new List<Player>();
            foreach (Player player in players)
            {
                if (player.IsFrost == false)
                {
                    NotFrostPlayers.Add(player);
                }
            }

            ((SimpleBoss)Body).CurrentDamagePlus = 30;
            if (NotFrostPlayers.Count != players.Count)
            {
                if (NotFrostPlayers.Count != 0)
                {
                    Body.PlayMovie("beat1", 0, 0);
                    Body.RangeAttacking(Body.X - 1000, Body.X + 1000, "beat1", 1500, NotFrostPlayers);
                }
                else
                {
                    Body.PlayMovie("beat1", 0, 0);
                    Body.RangeAttacking(Body.X - 1000, Body.X + 1000, "beat1", 1500, null);
                }
            }
            else
            {
                Body.Say("小的们给我上，好好教训敌人！", 1, 3300);
                Body.PlayMovie("renew", 3500, 0);
                Body.CallFuction(new LivingCallBack(CreateChild), 6000);
            }
        }

        private void FrostAttack()
        {
            int mtX = Game.Random.Next(660, 840);
            Body.MoveTo(mtX, Body.Y, "walk", 0, "", ((SimpleBoss)Body).NpcInfo.speed, new LivingCallBack(NextAttack));
        }

        private void AllAttack()
        {
            Body.CurrentDamagePlus = 0.5f;
            if (m_turn == 0)
            {
                int index = Game.Random.Next(0, AllAttackChat.Length);
                Body.Say(AllAttackChat[index], 1, 13000);
                Body.PlayMovie("beat1", 15000, 0);
                Body.RangeAttacking(Body.X - 1000, Body.X + 1000, "cry", 17000, null);
                m_turn++;
            }
            else
            {
                int index = Game.Random.Next(0, AllAttackChat.Length);
                Body.Say(AllAttackChat[index], 1, 0);
                Body.PlayMovie("beat1", 1000, 0);
                Body.RangeAttacking(Body.X - 1000, Body.X + 1000, "cry", 3000, null);
            }
        }

        private void KillAttack(int fx, int tx)
        {
            int index = Game.Random.Next(0, KillAttackChat.Length);
            if (m_turn == 0)
            {
                Body.CurrentDamagePlus = 10;
                Body.Say(KillAttackChat[index], 1, 13000);
                Body.PlayMovie("beat1", 15000, 0);
                Body.RangeAttacking(fx, tx, "cry", 17000, null);
                m_turn++;
            }
            else
            {
                Body.CurrentDamagePlus = 10;
                Body.Say(KillAttackChat[index], 1, 0);
                Body.PlayMovie("beat1", 2000, 0);
                Body.RangeAttacking(fx, tx, "cry", 4000, null);
            }
        }

        private void ProtectingWall()
        {
            if (IsEixt == 0)
            {
                m_wallLeft = ((PVEGame)Game).CreatePhysicalObj(Body.X - 65, 620, "wallLeft", "com.mapobject.asset.WaveAsset_01_left", "1", 1, 0);
                m_wallRight = ((PVEGame)Game).CreatePhysicalObj(Body.X + 65, 620, "wallLeft", "com.mapobject.asset.WaveAsset_01_right", "1", 1, 0);
                m_wallLeft.SetRect(-165, -169, 43, 330);
                m_wallRight.SetRect(128, -165, 41, 330);
                IsEixt = 1;
            }
            int index = Game.Random.Next(0, WallChat.Length);
            Body.Say(WallChat[index], 1, 0);
        }

        public void CreateChild()
        {
            Body.PlayMovie("renew", 100, 2000);
            ((SimpleBoss)Body).CreateChild(2, 520, 530, 400, 6, 1);
        }

        private void NextAttack()
        {
            int count = Game.Random.Next(1, 2);
            for (int i = 0; i < count; i++)
            {
                Player target = Game.FindRandomPlayer();
                if (target == null)
                    return;
                int index = Game.Random.Next(0, ShootChat.Length);
                Body.Say(ShootChat[index], 1, 0);

                if (target.X > Body.X)
                {
                    Body.ChangeDirection(1, 500);
                }
                else
                {
                    Body.ChangeDirection(-1, 500);
                }

                if (target != null && target.IsFrost == false)
                {
                    if (Body.ShootPoint(target.X, target.Y, ((SimpleBoss)Body).NpcInfo.CurrentBallId, 1000, 10000, 1, 1.5f, 2000))
                    {
                        Body.PlayMovie("beat2", 1500, 0);
                    }
                }
            }
        }
        public override void OnStopAttacking()
        {
            base.OnStopAttacking();
        }
    }
}
