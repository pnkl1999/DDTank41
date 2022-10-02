using Bussiness;
using Bussiness.Managers;
using Game.Logic.Actions;
using Game.Logic.CardEffect.Effects;
using Game.Logic.Effects;
using Game.Logic.Game.Logic;
using Game.Logic.PetEffects;
using Game.Logic.PetEffects.Element.Actives;
using Game.Logic.PetEffects.Element.Passives;
using Game.Logic.Phy.Maths;
using Game.Logic.Spells;
using SqlDataProvider.Data;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;

namespace Game.Logic.Phy.Object
{
    public class Player : TurnedLiving
    {
        public int BossCardCount;

        public int CanTakeOut;

        private static readonly int CARRY_TEMPLATE_ID = 10016;

        private int deputyWeaponResCount;

        public bool FinishTakeCard;

        public int GainGP;

        public int GainOffer;

        public bool HasPaymentTakeCard;

        private Dictionary<int, int> ItemFightBag;

        public bool LockDirection;

        private int m_AddWoundBallId;

        private int m_ballCount;

        private bool m_canGetProp;

        private BallInfo m_currentBall;

        private int m_changeSpecialball;

        private ItemInfo m_DeputyWeapon;

        private int m_energy;

        private int m_flyCoolDown;

        private ItemInfo m_Healstone;

        private bool m_isActive;

        private int m_loadingProcess;

        private int m_mainBallId;

        private int m_MultiBallId;

        private int m_oldx;

        public bool AttackInformation;

        public bool DefenceInformation;

        private int m_killedPunishmentOffer;

        private int m_powerRatio;

        public int MaxPsychic = 999;

        private int m_oldy;

        private IGamePlayer m_player;

        private int m_prop;

        private int m_shootCount;

        private int m_spBallId;

        private ArrayList m_tempBoxes;

        private ItemInfo m_weapon;

        public bool Ready;

        public Point TargetPoint;

        public int TotalAllCure;

        public int TotalAllExperience;

        public int TotalAllHitTargetCount;

        public int TotalAllHurt;

        public int TotalAllKill;

        public int TotalAllScore;

        public int TotalAllShootCount;

        public bool LimitEnergy;

        public bool CanFly = true;

        private readonly List<int> AllowedItems = new List<int>
        {
            10009,
            10010,
            10011,
            10012,
            10018,
            10021
        };

        private Random rand;

        private UsersPetInfo m_pet;

        private Dictionary<int, PetSkillInfo> _petSkillCd;

        private PetFightPropertyInfo petFightPropertyInfo;

        private BufferInfo m_bufferPoint;

        public int MOVE_SPEED;

        private double speedMultiplier;

        public event PlayerEventHandle PlayerSkip;

        private int m_useitemCount;

        private bool m_isaddturnequip;

        public bool IsAddTurnEquip
        {
            get
            {
                return m_isaddturnequip;
            }
            set
            {
                m_isaddturnequip = value;
            }
        }

        private PlayerConfig m_playerConfig;

        public PlayerConfig Config
        {
            get { return m_playerConfig; }
            set { m_playerConfig = value; }
        }


        public void OnPlayerSkip()
        {
            PlayerSkip?.Invoke(this);
        }

        public Dictionary<int, PetSkillInfo> PetSkillCD
        {
            get { return _petSkillCd; }
        }

        public int PowerRatio
        {
            get
            {
                return m_powerRatio;
            }
            set
            {
                m_powerRatio = value;
            }
        }

        public double SpeedMult
        {
            get
            {
                return speedMultiplier;
            }
            set
            {
                speedMultiplier = value / (double)base.STEP_X;
            }
        }

        public int StepX => (int)((double)base.STEP_X * speedMultiplier);

        public int StepY => (int)((double)base.STEP_Y * speedMultiplier);

        public int BallCount
        {
            get
            {
                return m_ballCount;
            }
            set
            {
                if (m_ballCount != value)
                {
                    m_ballCount = value;
                }
            }
        }

        public bool CanGetProp
        {
            get
            {
                return m_canGetProp;
            }
            set
            {
                if (m_canGetProp != value)
                {
                    m_canGetProp = value;
                }
            }
        }

        public BallInfo CurrentBall => m_currentBall;

        public int ChangeSpecialBall
        {
            get
            {
                return m_changeSpecialball;
            }
            set
            {
                m_changeSpecialball = value;
            }
        }

        public ItemInfo DeputyWeapon
        {
            get
            {
                return m_DeputyWeapon;
            }
            set
            {
                m_DeputyWeapon = value;
            }
        }

        public int deputyWeaponCount => deputyWeaponResCount;

        public int Energy
        {
            get
            {
                return m_energy;
            }
            set
            {
                m_energy = value;
            }
        }

        public int flyCount => m_flyCoolDown;

        public bool IsActive => m_isActive;

        public bool IsSpecialSkill => m_currentBall.ID == m_spBallId;

        public int LoadingProcess
        {
            get
            {
                return m_loadingProcess;
            }
            set
            {
                if (m_loadingProcess != value)
                {
                    m_loadingProcess = value;
                    if (m_loadingProcess >= 100)
                    {
                        OnLoadingCompleted();
                    }
                }
            }
        }

        public int KilledPunishmentOffer
        {
            get
            {
                return m_killedPunishmentOffer;
            }
            set
            {
                m_killedPunishmentOffer = value;
            }
        }

        public int OldX
        {
            get
            {
                return m_oldx;
            }
            set
            {
                m_oldx = value;
            }
        }

        public int OldY
        {
            get
            {
                return m_oldy;
            }
            set
            {
                m_oldy = value;
            }
        }

        public IGamePlayer PlayerDetail => m_player;

        public int Prop
        {
            get
            {
                return m_prop;
            }
            set
            {
                m_prop = value;
            }
        }

        public new int ShootCount
        {
            get
            {
                return m_shootCount;
            }
            set
            {
                if (m_shootCount != value)
                {
                    m_shootCount = value;
                    m_game.SendGameUpdateShootCount(this);
                }
            }
        }
        private int m_isBombOrIgnoreArmor;

        public int IsBombOrIgnoreAemor
        {
            get { return m_isBombOrIgnoreArmor; }
            set { m_isBombOrIgnoreArmor = value; }
        }


        public ItemInfo Weapon => m_weapon;

        public UsersPetInfo Pet => m_pet;

        public event PlayerEventHandle AfterPlayerShooted;

        public event PlayerEventHandle BeforeBomb;

        public event PlayerEventHandle BeforePlayerShoot;

        public event PlayerEventHandle CollidByObject;

        public event PlayerEventHandle LoadingCompleted;

        public event PlayerEventHandle PlayerShootCure;

        public event PlayerEventHandle PlayerBeginMoving;

        public event PlayerEventHandle PlayerBuffSkillPet;

        public event PlayerEventHandle PlayerClearBuffSkillPet;

        public event PlayerEventHandle PlayerCure;

        public event PlayerEventHandle PlayerGuard;

        public event PlayerEventHandle PlayerShoot;

        public event PlayerEventHandle PlayerCompleteShoot;

        public event PlayerEventHandle PlayerAnyShellThrow;

        public event PlayerSecondWeaponEventHandle PlayerUseSecondWeapon;

        public event PlayerMissionEventHandle MissionEventHandle;

        public event PlayerEventHandle PlayerBeforeReset;

        public event PlayerEventHandle PlayerAfterReset;

        public Player(IGamePlayer player, int id, BaseGame game, int team, int maxBlood)
            : base(id, game, team, "", "", maxBlood, 0, 1)
        {
            m_rect = new Rectangle(-15, -20, 30, 30);
            _petSkillCd = new Dictionary<int, PetSkillInfo>();
            m_player = player;
            m_player.GamePlayerId = id;
            m_canGetProp = true;
            Grade = player.PlayerCharacter.Grade;
            TotalAllHurt = 0;
            TotalAllHitTargetCount = 0;
            TotalAllShootCount = 0;
            TotalAllKill = 0;
            TotalAllExperience = 0;
            TotalAllScore = 0;
            TotalAllCure = 0;
            m_loadingProcess = 0;
            ChangeSpecialBall = 0;
            m_prop = 0;
            if (base.AutoBoot)
            {
                base.VaneOpen = true;
            }
            else
            {
                base.VaneOpen = player.PlayerCharacter.Grade >= 9;
            }

            m_weapon = m_player.MainWeapon;
            m_DeputyWeapon = m_player.SecondWeapon;
            m_Healstone = m_player.Healstone;

            m_pet = player.Pet;

            if (game != null)
            {
                InitFightBuffer(player.FightBuffs);
                if (m_pet != null)
                {
                    //PetMP = 10;
                    base.isPet = true;
                    PetEffects.PetBaseAtt = GetPetBaseAtt();
                    InitPetSkillEffect();
                    petFightPropertyInfo = PetMgr.FindFightProperty(player.PlayerCharacter.evolutionGrade);
                }
                m_tempBoxes = new ArrayList();
                m_flyCoolDown = 2;
                speedMultiplier = 1.0;
                MOVE_SPEED = 2;
                ItemFightBag = new Dictionary<int, int>();


                m_player.GameId = id;
                m_isActive = true;



                base.BlockTurn = false;
                deputyWeaponResCount = ((m_DeputyWeapon == null) ? 1 : (m_DeputyWeapon.StrengthenLevel + 1));
                if (m_weapon != null)
                {
                    BallConfigInfo ball = BallConfigMgr.FindBall(m_weapon.TemplateID);
                    if (m_weapon.IsValidGoldItem())
                    {
                        ball = BallConfigMgr.FindBall(m_weapon.GoldEquip.TemplateID);
                    }
                    m_mainBallId = ball.Common;
                    m_spBallId = ball.Special;
                    m_AddWoundBallId = ball.CommonAddWound;
                    m_MultiBallId = ball.CommonMultiBall;
                }
                InitBuffer(m_player.EquipEffect);
                m_energy = (m_player.PlayerCharacter.AgiAddPlus + m_player.PlayerCharacter.Agility) / 30 + 240;
                m_useitemCount = 0;
                m_maxBlood = m_player.PlayerCharacter.hp;
                if (base.FightBuffers.ConsortionAddMaxBlood > 0)
                {
                    m_maxBlood += m_maxBlood * base.FightBuffers.ConsortionAddMaxBlood / 100;
                }
                m_maxBlood += m_player.PlayerCharacter.HpAddPlus + base.FightBuffers.WorldBossHP + base.FightBuffers.WorldBossHP_MoneyBuff + base.PetEffects.MaxBlood;
                CanFly = true;
                m_powerRatio = 100;
                if (game != null && !game.IsSpecialPVE())
                {
                    BufferInfo fightBuffByType = GetFightBuffByType(BuffType.Agility);
                    if (fightBuffByType != null && m_player.UsePayBuff(BuffType.Agility))
                    {
                        m_bufferPoint = fightBuffByType;
                    }
                }
                propsBloqueados = new List<int>();
                m_isBombOrIgnoreArmor = 0;
                m_playerConfig = new PlayerConfig();
                m_isaddturnequip = false;
            }
        }

        public int GetPetBaseAtt()
        {
            try
            {
                string[] skillArray = m_pet.SkillEquip.Split('|');
                for (int i = 0; i < skillArray.Length; i++)
                {
                    int skillID = Convert.ToInt32(skillArray[i].Split(',')[0]);
                    PetSkillInfo newBall = PetMgr.FindPetSkill(skillID);
                    if (newBall != null && newBall.Damage > 0)
                    {
                        return newBall.Damage;
                    }
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("______________GetPetBaseAtt ERROR______________");
                Console.WriteLine(e.Message);
                Console.WriteLine(e.StackTrace);
                Console.WriteLine("_______________________________________________");
                return 0;
            }
            return 0;
        }

        public bool CanUseItem(ItemTemplateInfo item)
        {
            if (m_currentBall.IsSpecial() && !AllowedItems.Contains(item.TemplateID))
            {
                return false;
            }
            if (m_energy < item.Property4)
            {
                return false;
            }
            if (!base.IsAttacking)
            {
                if (!base.IsLiving && base.Team == m_game.CurrentLiving.Team)
                {
                    return IsActive;
                }
                return false;
            }
            if (propsBloqueados.Contains(item.TemplateID))
            {
                return false;
            }
            return true;
        }

        public bool CanUseItem(ItemTemplateInfo item, int place)
        {
            if (m_currentBall.IsSpecial() && !AllowedItems.Contains(item.TemplateID))
            {
                return false;
            }
            if (!base.IsLiving && place == -1)
            {
                return base.psychic >= item.Property7;
            }
            if (!base.IsLiving && place != -1 && base.Team == m_game.CurrentLiving.Team)
            {
                return true;
            }
            if (m_energy < item.Property4)
            {
                return false;
            }
            if (!base.IsAttacking)
            {
                if (!base.IsLiving && base.Team == m_game.CurrentLiving.Team)
                {
                    return IsActive;
                }
                return false;
            }
            return true;
        }

        public void capnhatstate(string loai1, string loai2)
        {
            m_game.capnhattrangthai(this, loai1, loai2);
        }

        public override void CollidedByObject(Physics phy)
        {
            base.CollidedByObject(phy);
            if (phy is SimpleBomb)
            {
                OnCollidedByObject();
            }
        }

        public bool CheckCanUseItem(ItemTemplateInfo item)
        {
            switch (item.TemplateID)
            {
                case 10001:
                    if (!ItemFightBag.ContainsKey(10003) || !ItemFightBag.ContainsKey(10002))
                    {
                        if (ItemFightBag.ContainsKey(10001) && ItemFightBag[10001] >= 2)
                        {
                            return false;
                        }
                        break;
                    }
                    return false;
                case 10002:
                    if (!ItemFightBag.ContainsKey(10003) || !ItemFightBag.ContainsKey(10001))
                    {
                        if (ItemFightBag.ContainsKey(10002) && ItemFightBag[10002] >= 2)
                        {
                            return false;
                        }
                        break;
                    }
                    return false;
                case 10003:
                    if (!ItemFightBag.ContainsKey(10024) && !ItemFightBag.ContainsKey(10025))
                    {
                        if (ItemFightBag.ContainsKey(10001) && ItemFightBag.ContainsKey(10002))
                        {
                            return false;
                        }
                        break;
                    }
                    return false;
                case 10025:
                    if (ItemFightBag.ContainsKey(10003) || ItemFightBag.ContainsKey(10024))
                    {
                        return false;
                    }
                    break;
            }
            if (!ItemFightBag.ContainsKey(item.TemplateID))
            {
                ItemFightBag.Add(item.TemplateID, 1);
            }
            else
            {
                ItemFightBag[item.TemplateID]++;
            }
            return true;
        }

        public bool CheckShootPoint(int x, int y)
        {
            return true;
        }

        public void DeadLink()
        {
            m_isActive = false;
            if (base.IsLiving)
            {
                Die();
            }
        }

        public override void Die()
        {
            if (base.IsLiving)
            {
                m_y -= 70;
                base.Die();
            }
        }

        public void InitBuffer(List<int> equpedEffect)
        {
            for (int index = 0; index < equpedEffect.Count; index++)
            {
                ItemTemplateInfo itemTemplate = ItemMgr.FindItemTemplate(equpedEffect[index]);
                switch (itemTemplate.Property3)
                {
                    case 1:
                        new AddAttackEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 2:
                        new AddDefenceEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 3:
                        new AddAgilityEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 4:
                        new AddLuckyEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 5:
                        new AddDamageEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 6:
                        new ReduceDamageEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 7:
                        new AddBloodEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 8:
                        new FatalEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 9:
                        new IceFronzeEquipEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 10:
                        new NoHoleEquipEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 11:
                        new AtomBombEquipEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 12:
                        new ArmorPiercerEquipEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 13:
                        new AvoidDamageEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 14:
                        new MakeCriticalEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 15:
                        new AssimilateDamageEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 16:
                        new AssimilateBloodEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 17:
                        new SealEquipEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 18:
                        new AddTurnEquipEffect(itemTemplate.Property4, itemTemplate.Property5, itemTemplate.TemplateID).Start(this);
                        break;
                    case 19:
                        new AddDanderEquipEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 20:
                        new ReflexDamageEquipEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 21:
                        new ReduceStrengthEquipEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 22:
                        new ContinueReduceBloodEquipEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 23:
                        new LockDirectionEquipEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 24:
                        new AddBombEquipEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 25:
                        new ContinueReduceDamageEquipEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                    case 26:
                        new RecoverBloodEffect(itemTemplate.Property4, itemTemplate.Property5).Start(this);
                        break;
                }
            }
        }

        public void InitPetSkillEffect()
        {
            string[] listSkills = m_pet.SkillEquip.Split('|');
            PetSkillInfo skillInfo = null;
            foreach (string skill in listSkills)
            {
                int skillId = int.Parse(skill.Split(',')[0]);
                skillInfo = PetMgr.FindPetSkill(skillId);
                if (skillInfo == null)
                    continue;
                string[] elementIDs = skillInfo.ElementIDs.Split(',');
                int coldDown = skillInfo.ColdDown;
                int probability = skillInfo.Probability;
                int delay = skillInfo.Delay;
                int gameType = skillInfo.GameType;
                if (!_petSkillCd.ContainsKey(skillId))
                {
                    _petSkillCd.Add(skillId, skillInfo);
                }

                //Console.WriteLine(string.Format("InitPetSkillEffect, skillInfo.ElementIDs: {0}", skillInfo.ElementIDs));
                foreach (string element in elementIDs)
                {
                    if (string.IsNullOrEmpty(element))
                        continue;

                    switch (element)
                    {
                        #region Skill Chung
                        case "1017"://Di chuyển không thể. Duy trì 2 TURN
                            new AE1017(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1021"://miễn kháng. Duy trì 2 TURN
                            new AE1021(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1038"://hiệu ứng dẫn đường, duy trì 1 turn.
                            new AE1038(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1082"://Luôn miễn kháng
                            new AE1082(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1138":// 100% xác suất bạo kích
                            new AE1138(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1325"://Thú cưng sau khi kết thúc mỗi turn có 100% xác suất tấn công địch, gây 15% sát thương.
                            new PE1325(coldDown, probability, gameType, skillId, delay, "1110").Start(this);
                            break;
                        case "1326"://Thú cưng sau khi kết thúc mỗi turn có 100% xác suất tấn công địch, gây 25% sát thương.
                            new PE1326(coldDown, probability, gameType, skillId, delay, "1110").Start(this);
                            break;
                        case "1327"://Thú cưng sau khi kết thúc mỗi turn có 100% xác suất tấn công địch, gây 36% sát thương.
                            new PE1327(coldDown, probability, gameType, skillId, delay, "1110").Start(this);
                            break;
                        #endregion
                        #region Gà Con
                        case "1328"://Bắn 1 Đạn Theo Dõi, gây 100% sát thương cơ bản.
                            new AE1328(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1329"://Bắn 1 Đạn Theo Dõi, gây 130% sát thương cơ bản.
                            new AE1329(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1330"://Bắn 1 Đạn Theo Dõi, gây 155% sát thương cơ bản.
                            new AE1330(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1331"://Nhận hiệu quả phòng thủ +15%, duy trì 2 turn.
                            new AE1331(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1332"://Nhận hiệu quả phòng thủ +20%, duy trì 2 turn.
                            new AE1332(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1333"://Nhận hiệu quả phòng thủ +30%, duy trì 2 turn.
                            new AE1333(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1334"://tấn công -20%,  duy trì 2 turn.
                            new AE1334(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1336"://Nhận thêm 250 điểm hộ giáp, khi giải trừ sẽ mất hiệu quả cộng thêm, tối đa cộng dồn 3 lần.
                            new AE1336(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1337"://Nhận thêm 365 điểm hộ giáp, khi giải trừ sẽ mất hiệu quả cộng thêm, tối đa cộng dồn 3 lần.
                            new AE1337(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1338"://Hiệu quả giải trừ.
                            //new AE1339(coldDown, probability, gameType, skillId, delay, "1339").Start(this);
                            new AE1339(coldDown, probability, gameType, skillId, delay, "1338").Start(this);
                            break;
                        case "1340"://Mỗi lần bắn gây sát thương bằng 2% HP hiện tại của bản thân
                            new PE1340(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1341"://Mỗi lần bắn gây sát thương bằng 3% HP hiện tại của bản thân
                            new PE1341(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1342"://Tăng 30% sát thương. Hiệu quả mất khi di chuyển.
                            new AE1342(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1343"://Sát thương +45%. Hiệu quả mất khi di chuyển.
                            new AE1343(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1344": //may mắn +10%. Hiệu quả mất khi di chuyển.
                            new AE1344(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1346"://giảm 30% hộ giáp. Hiệu quả mất khi di chuyển.
                            new AE1346(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1347"://hộ giáp -25%. Hiệu quả mất khi di chuyển.
                            new AE1347(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1345": //may mắn +15%. Hiệu quả mất khi di chuyển.
                            new AE1345(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1348"://Sau khi di chuyển sẽ giải trừ hiệu quả pháo đài V3
                            new AE1349(coldDown, probability, gameType, skillId, delay, "1349").Start(this);
                            new AE1350(coldDown, probability, gameType, skillId, delay, "1350").Start(this);
                            break;
                        case "1355"://Mỗi lần bị tấn công trúng chính xác, nhận 40 sát thương thêm, tối đa cộng dồn 4 lần, sau khi turn bản thân kết thúc, giảm 2 lần hiệu quả thêm.
                            new PE1355(coldDown, probability, gameType, skillId, delay, "1355").Start(this);
                            break;
                        case "1357"://Mỗi lần bị tấn công trúng chính xác, nhận 55 sát thương thêm, tối đa cộng dồn 6 lần, sau khi turn bản thân kết thúc, giảm 2 lần hiệu quả thêm.
                            new PE1357(coldDown, probability, gameType, skillId, delay, "1357").Start(this);
                            break;
                        #endregion
                        #region Kiến
                        case "1032"://Mỗi lần bị tấn công giảm thêm 5% sát thương, duy trì 1 turn.
                            new AE1445(coldDown, probability, gameType, skillId, delay, "1032").Start(this);
                            break;
                        case "1033"://Mỗi lần bị tấn công giảm thêm 5% sát thương, duy trì 1 turn.
                            new AE1445(coldDown, probability, gameType, skillId, delay, "1033").Start(this);
                            break;
                        case "1034"://Mỗi lần bị tấn công giảm thêm 10% sát thương, duy trì 1 turn.
                            new AE1446(coldDown, probability, gameType, skillId, delay, "1034").Start(this);
                            break;
                        case "1039":// gây 150% sát thương cơ bản
                            new AE1039(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1067"://mỗi lần bị tấn công phản đòn bằng 30% tổng sát thương, duy trì 2 turn. Chỉ hiệu quả khi chiến đấu..
                            new AE1067(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1068"://mỗi lần bị tấn công phản đòn bằng 50% tổng sát thương, duy trì 2 turn. Chỉ hiệu quả khi chiến đấu.
                            new AE1068(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1117"://Hoàn toàn không chịu sát thương kéo dài 1 hiệp,chỉ khi đối chiến vối người mới có hiệu lực
                            new AE1117(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1133":// gây 120% sát thương cơ bản
                            new AE1133(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1134":// gây 180% sát thương cơ bản
                            new AE1134(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1136"://Bản thân thêm vỏ phản xạ, duy trì 2 turn. Chỉ hiệu quả khi chiến đấu.
                            new AE1136(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1137"://duy trì phản kích.
                            new PE1137(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1439"://Ném 1 Kiến Lửa, bản thân tăng 100 hộ giáp, duy trì 2 turn.
                            new AE1439(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1440"://Ném 1 Kiến Lửa, bản thân tăng 300 hộ giáp, duy trì 2 turn.
                            new AE1440(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1441"://Ném 1 Kiến Lửa, bản thân tăng 500 hộ giáp, duy trì 2 turn.
                            new AE1441(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1442"://Nhận được 500 điểm giảm thương.
                            new AE1442(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1443"://Nhận được 500 +10% điểm giảm thương.
                            new AE1443(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1444"://Nhận được 500 +20% điểm giảm thương.
                            new AE1444(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1457"://Mỗi lần bị tấn công tăng 1 điểm ma pháp.
                            new PE1457(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1449"://Tăng 6% hộ giáp.
                            new PE1449(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1450"://Tăng 10% hộ giáp.
                            new PE1450(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1451"://Tăng 6% phòng thủ.
                            new PE1451(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1452"://Tăng 10% phòng thủ.
                            new PE1452(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1455"://Hoàn toàn không chịu sát thương, hồi phục 5% HP, duy trì 1 turn. Chỉ hiệu quả khi chiến đấu.
                            new AE1455(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1456"://Hoàn toàn không chịu sát thương, hồi phục 15% HP, duy trì 1 turn. Chỉ hiệu quả khi chiến đấu.
                            new AE1456(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1459"://Mỗi lần bị tấn công có 20% xác suất phản đòn bằng 3% HP hiện tại..
                            new PE1459(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1460"://Mỗi lần bị tấn công có 20% xác suất phản đòn bằng 5% HP hiện tại..
                            new PE1460(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        #endregion
                        #region Đấu Sĩ
                        case "1022"://Bắn bất kỳ loại đạn nào trong TURN cũng sẽ tăng 100 hộ giáp cho đồng đội, duy trì 2 TURN.
                            new AE1022(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1023"://Bắn bất kỳ loại đạn nào trong TURN cũng sẽ tăng 300 hộ giáp cho đồng đội, duy trì 2 TURN.
                            new AE1023(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1024"://Bắn bất kỳ loại đạn nào trong TURN cũng sẽ tăng 100 sát thương cho đồng đội, duy trì 2 TURN.
                            new AE1024(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1025"://Bắn bất kỳ loại đạn nào trong TURN cũng sẽ tăng 300 sát thương cho đồng đội, duy trì 2 TURN. 
                            new AE1025(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1040"://tăng 100đ may mắn cho bản thân, duy trì 2 turn.
                            new AE1040(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1041"://tăng 300đ may mắn cho bản thân, duy trì 2 turn.
                            new AE1041(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1042"://tăng 500đ may mắn cho bản thân, duy trì 2 turn.
                            new AE1042(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1056"://Hồi phục 1500 HP cho tất cả đồng đội trên toàn bản đồ. 
                            new AE1056(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1057"://Hồi phục 3000 HP cho tất cả đồng đội trên toàn bản đồ.
                            new AE1057(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1074"://Tăng 300 điểm hiệu quả cho các vũ khí phụ loại thiên sứ ban phúc.
                            new PE1074(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1075"://Tăng 600 điểm hiệu quả cho các vũ khí phụ loại thiên sứ ban phúc.
                            new PE1075(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1078"://Sử dụng vũ khí phụ loại khiên sẽ lập tức hồi phục 500 HP.
                            new PE1078(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1079"://Sử dụng vũ khí phụ loại khiên sẽ lập tức hồi phục 1000 HP.
                            new PE1079(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1092"://Tăng 100 công kích cho tất cả chiến hữu. Duy trì 3 TURN.
                            new AE1092(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1093"://Tăng 300 công kích cho tất cả chiến hữu. Duy trì 3 TURN.
                            new AE1093(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1094"://Tăng 100 phòng ngự cho tất cả chiến hữu. Duy trì 3 TURN.
                            new AE1094(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1095"://Tăng 300 phòng ngự cho tất cả chiến hữu. Duy trì 3 TURN.
                            new AE1095(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1096"://Tăng 100 nhanh nhẹn cho tất cả chiến hữu. Duy trì 3 TURN.
                            new AE1096(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1097"://Tăng 300 nhanh nhẹn cho tất cả chiến hữu. Duy trì 3 TURN.
                            new AE1097(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1098"://Tăng 100 may mắn cho tất cả chiến hữu. Duy trì 3 TURN.
                            new AE1098(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1099"://Tăng 300 may mắn cho tất cả chiến hữu. Duy trì 3 TURN.
                            new AE1099(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1100"://Tăng 1000 HP tối đa cho tất cả chiến hữu. Duy trì 3 TURN.
                            new AE1100(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1101"://Tăng 2000 HP tối đa cho tất cả chiến hữu. Duy trì 3 TURN.
                            new AE1101(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1107"://TURN đầu tiên sẽ nhận được 50 ma pháp.
                            new PE1107(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1109"://Giải trừ 50 điểm phép thuật
                            new PE1110(coldDown, probability, gameType, skillId, delay, "1110").Start(this);
                            break;
                        case "1122"://10% sat thương công kích
                            new PE1122(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1123"://20% sat thương công kích
                            new PE1123(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1124"://30% sat thương công kích
                            new PE1124(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        #endregion
                        #region Rồng Cổ Đại
                        case "1139"://40% sat thương công kích
                            new PE1139(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1149"://50% sat thương công kích
                            new PE1149(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1150"://mục tiêu bị đánh trúng mỗi turn mất 1% HP, duy trì 3 turn. (Chỉ có hiệu quả khi chiến đấu)
                            new AE1150(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1151"://mục tiêu bị đánh trúng mỗi turn mất 2% HP, duy trì 3 turn. (Chỉ có hiệu quả khi chiến đấu)
                            new AE1151(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1152"://mục tiêu bị đánh trúng mỗi turn mất 3% HP, duy trì 3 turn. (Chỉ có hiệu quả khi chiến đấu)
                            new AE1152(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1153"://Sát thương cơ bản +15%, duy trì 3 turn.
                            new AE1153(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1154"://Sát thương cơ bản +25%, duy trì 3 turn.
                            new AE1154(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1155"://hộ giáp giảm 500 điểm, duy trì 3 turn.
                            new AE1155(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1156"://hộ giáp giảm 650 điểm, duy trì 3 turn.
                            new AE1156(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1161"://Chân Long Tại Thiên, gây cho tất cả địch 3000 sát thương. (Chỉ có hiệu quả khi chiến đấu).
                            new AE1161(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1162"://Chân Long Tại Thiên, gây cho tất cả địch 5000 sát thương. (Chỉ có hiệu quả khi chiến đấu).
                            new AE1162(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1163"://Tấn công tăng 150.
                            new PE1163(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1164"://Tấn công tăng 300..
                            new PE1164(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1165"://sát thương tăng 100.
                            new PE1165(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1166"://sát thương tăng 200.
                            new PE1166(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1170"://Mỗi lần tới lượt địch tấn công, địch sẽ chịu bỏng Ấn Rồng Lửa! Mất 1000 HP, chỉ có hiệu quả khi chiến đấu. Duy trì 3 turn.
                            new AE1170(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1171"://Mỗi lần tới lượt địch tấn công, địch sẽ chịu bỏng Ấn Rồng Lửa! Mất 2000 HP chỉ có hiệu quả khi chiến đấu. Duy trì 3 turn.
                            new AE1171(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1172"://Mỗi lần bị tấn công, có xác suất 50% thức tỉnh Hồn Rồng hồi phục 2% HP. Duy trì 3 turn.
                            new AE1172(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1173"://Mỗi lần bị tấn công, có xác suất 50% thức tỉnh Hồn Rồng hồi phục 4% HP. Duy trì 3 turn.
                            new AE1173(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1174"://Rồng Bảo Vệ Lv1. Duy trì 3 turn.
                            new AE1174(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1175"://Rồng Bảo Vệ Lv2. Duy trì 3 turn.
                            new AE1175(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1176"://Mỗi lần tới lượt địch tấn công, địch sẽ chịu bỏng Ấn Rồng Lửa! Mất 2% HP hiện tại, chỉ có hiệu quả khi chiến đấu. Duy trì 3 turn.
                            new AE1176(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1177"://Mỗi lần tới lượt địch tấn công, địch sẽ chịu bỏng Ấn Rồng Lửa! Mất 4% HP hiện tại, chỉ có hiệu quả khi chiến đấu. Duy trì 3 turn.
                            new AE1177(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1322"://Khi chịu sát thương, mỗi mất 3500 HP nhận 1 điểm ma pháp.
                            new PE1322(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1323"://Chân Long Tại Thiên, diệt nhanh địch đang có HP dưới 5%. (Chỉ có hiệu quả khi chiến đấu)
                            new AE1323(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1324"://Chân Long Tại Thiên, diệt nhanh địch đang có HP dưới 10%. (Chỉ có hiệu quả khi chiến đấu)
                            new AE1324(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        #endregion
                        #region Mầm Xanh
                        case "1358"://Ném 1 hạt giống, bản thân mỗi turn hồi phục 2% HP, duy trì 2 turn.
                            new AE1358(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1359"://Ném 1 hạt giống, bản thân mỗi turn hồi phục 2% HP, duy trì 2 turn.
                            new AE1359(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1360"://Ném 1 hạt giống, bản thân mỗi turn hồi phục 2% HP, duy trì 2 turn.
                            new AE1360(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1361"://Bản thân và đơn vị xung quanh mỗi turn hồi phục 2% +800 HP, duy trì 3 turn
                            new AE1361(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1362"://Bản thân và đơn vị xung quanh mỗi turn hồi phục 3% +1000 HP, duy trì 3 turn
                            new AE1362(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1363"://Bản thân và đơn vị xung quanh mỗi turn hồi phục 3% +1500 HP, duy trì 4 turn
                            new AE1363(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1364"://Đồng đội xung quanh hồi phục ngay 8% HP
                            new AE1364(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1365"://Đồng đội xung quanh hồi phục ngay 10% HP
                            new AE1365(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1366"://Đồng đội xung quanh mỗi turn hồi phục 3% HP, duy trì 3 turn.
                            new AE1366(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1367"://Đồng đội xung quanh mỗi turn hồi phục 4% HP, duy trì 4 turn.
                            new AE1367(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1368"://Thêm Khiên Phòng Hộ cho tất cả đồng đội, mỗi lần bị bắn trúng hồi phục 0.3% HP.
                            new PE1368(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1369"://Thêm Khiên Phòng Hộ cho tất cả đồng đội, mỗi lần bị bắn trúng hồi phục 0.4% HP, nếu HP thấp hơn 20%, hiệu quả hồi phục x2.
                            new PE1369(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1372"://Khi bắn vũ khí phụ loại thiên sứ ban phúc, kèm hiệu quả hồi phục bản thân 3% HP.
                            new PE1372(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1373"://Khi bắn vũ khí phụ loại thiên sứ ban phúc, kèm hiệu quả hồi phục bản thân 6% HP.
                            new PE1373(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1374"://Bắn 1 Hạt Bay, khi hạt giống nổ hồi phục HP đồng đội xung quanh, giảm HP địch, hạt giống mỗi giây tăng 3% HP..
                            new AE1374(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1375"://Bắn 1 Hạt Bay, khi hạt giống nổ hồi phục HP đồng đội xung quanh, giảm HP địch, hạt giống mỗi giây tăng 6% HP..
                            new AE1375(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1376"://Khi đồng đội bắt đầu turn nếu được kỹ năng Mầm Xanh duy trì hiệu quả hồi phục, bản thân sẽ tăng 1 điểm ma pháp.
                            new PE1376(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        #endregion
                        #region Phụng Hoàng Băng
                        case "1178"://tăng 100đ tấn công cho bản thân, duy trì 2 turn.
                            new AE1178(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1179"://tăng 300đ tấn công cho bản thân, duy trì 2 turn.
                            new AE1179(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1180"://tăng 500đ tấn công cho bản thân, duy trì 2 turn.
                            new AE1180(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1181"://Tăng 100 điểm hộ giáp cho tất cả đồng đội, duy trì 2 turn.Không cộng dồn để dùng.
                            new AE1181(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1182"://Tăng 200 điểm hộ giáp cho tất cả đồng đội, duy trì 2 turn.Không cộng dồn để dùng.
                            new AE1182(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1183"://Tăng 300 điểm hộ giáp cho tất cả đồng đội, duy trì 2 turn.Không cộng dồn để dùng.
                            new AE1183(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1184"://tăng 150 điểm sát thương, di chuyển sẽ hủy. Khi HP không đủ, dùng kỹ năng này sẽ tử vong.
                            new AE1184(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1185"://tăng 300 điểm sát thương, di chuyển sẽ hủy. Khi HP không đủ, dùng kỹ năng này sẽ tử vong.
                            new AE1185(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1186"://Mỗi turn giảm 500 HP, di chuyển sẽ hủy. Khi HP không đủ, dùng kỹ năng này sẽ tử vong.
                            new AE1186(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1187"://Mỗi turn giảm 800 HP, di chuyển sẽ hủy. Khi HP không đủ, dùng kỹ năng này sẽ tử vong.
                            new AE1187(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1188"://Xóa hiệu ứng Địa Ngục Băng Giá
                            new AE1189(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1190"://Tăng nhanh nhẹn 300 điểm.
                            new PE1190(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1191"://Tăng nhanh nhẹn 500 điểm.
                            new PE1191(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1192"://Tăng 100 điểm tấn công cho toàn bộ đồng đội.
                            new PE1192(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1193"://Tăng 300 điểm tấn công cho toàn bộ đồng đội.
                            new PE1193(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1194"://Tăng 200 điểm tấn công, duy trì 1 turn.
                            new AE1194(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1195"://Tăng 300 điểm tấn công, duy trì 1 turn.
                            new AE1195(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1196"://100 sát thương, duy trì 1 turn.
                            new AE1196(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1197"://150 sát thương, duy trì 1 turn.
                            new AE1197(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1198"://Tăng 30% crit, duy trì 1 turn.
                            new AE1198(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1199"://Tăng 50% crit, duy trì 1 turn.
                            new AE1199(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1200"://Khi đến lượt thi triển, tăng 2 điểm ma pháp cho toàn bộ thú cưng cùng phe.
                            new PE1200(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1224"://Mỗi turn giảm 500 HP.
                            new AE1224(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1225"://Mỗi turn giảm 800 HP.
                            new AE1225(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        #endregion
                        #region Ma Xà
                        case "1201"://Bắn ra nọc độc, mục tiêu trúng phải giảm 100 sát thương, duy trì 3 turn.
                            new AE1201(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1202"://Bắn ra nọc độc, mục tiêu trúng phải giảm 200 sát thương, duy trì 3 turn.
                            new AE1202(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1203"://Bắn ra nọc độc, mục tiêu trúng phải giảm 300 sát thương, duy trì 3 turn.
                            new AE1203(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1204"://Giảm 300 tấn công toàn bộ phe địch, duy trì 2 turn. Kỹ năng chỉ hiệu quả trong chiến đấu.
                            new AE1204(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1205"://Giảm 500 tấn công toàn bộ phe địch, duy trì 2 turn. Kỹ năng chỉ hiệu quả trong chiến đấu.
                            new AE1205(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1206"://Giảm 300 phòng thủ toàn bộ phe địch, duy trì 2 turn. Kỹ năng chỉ hiệu quả trong chiến đấu.
                            new AE1206(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1207"://Giảm 500 phòng thủ toàn bộ phe địch, duy trì 2 turn. Kỹ năng chỉ hiệu quả trong chiến đấu.
                            new AE1207(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1208"://Giảm 10 điểm ma pháp của tất cả thú cưng bên địch. Kỹ năng chỉ hiệu quả trong chiến đấu.
                            new AE1208(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1209"://Giảm 30 điểm ma pháp của tất cả thú cưng bên địch. Kỹ năng chỉ hiệu quả trong chiến đấu.
                            new AE1209(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1210"://Mỗi turn giảm 500 HP. Duy trì 3 turn.
                            new AE1210(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1211"://Mỗi turn giảm 1000 HP. Duy trì 3 turn.
                            new AE1211(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1212"://tăng 20% bạo kích. Duy trì 3 turn.
                            new AE1212(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1213"://tăng 50% bạo kích. Duy trì 3 turn.
                            new AE1213(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1214"://Tăng 100 hộ giáp
                            new PE1214(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1215"://Tăng 200 hộ giáp
                            new PE1215(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1216"://Tăng 1500 HP tối đa.
                            new PE1216(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1217"://Tăng 3000 HP tối đa.
                            new PE1217(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1218":
                        case "1219":
                            //empty skill element.
                            break;
                        case "1220"://Giảm 100 hộ giáp tất cả phe địch, duy trì 2 turn.
                            new AE1220(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1221"://Giảm 200 hộ giáp tất cả phe địch, duy trì 2 turn.
                            new AE1221(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1222"://Không thể di chuyển, duy trì 2 turn.
                            new AE1222(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1223"://Mỗi lần bị tấn công nhận được 2 điểm ma pháp.
                            new PE1223(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1226"://Mỗi turn giảm 500 HP.
                            new AE1226(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1227"://Mỗi turn giảm 1000 HP.
                            new AE1227(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        #endregion
                        #region Tôn Ngộ Không
                        case "1036":// gây 120% sát thương cơ bản
                            new AE1036(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1418"://gây 150% sát thương cơ bản
                            new AE1418(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1419"://gây 180% sát thương cơ bản
                            new AE1419(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1421":// 20% xác suất bạo kích, 2 turn
                            new AE1421(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1422"://5% Tăng Sát Thương
                            new PE1422(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1423"://10% Giảm Hộ Giáp
                            new PE1423(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1424"://10% Tăng Ma Công
                            new PE1424(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1425"://15% Giảm Ma Kháng
                            new PE1425(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1426"://Tất cả phe địch không thể hành động 1 turn. (Chỉ có hiệu quả khi chiến đấu)
                            new AE1426(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1427"://ma pháp -10 điểm. (Chỉ có hiệu quả khi chiến đấu)
                            new AE1427(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1428"://Giảm 10% sát thương phải chịu
                            new PE1428(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1429"://Giảm 20% sát thương phải chịu
                            new PE1429(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1430"://có 20% xác suất miễn bị bạo kích.
                            new PE1430(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1431"://có 30% xác suất miễn bị bạo kích.
                            new PE1431(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1432"://Đánh dấu tất cả người chơi phe địch ẩn thân, duy trì 2 turn (chỉ có hiệu quả khi chiến đấu)
                            new AE1432(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1433"://khiến địch chịu thêm 20% sát thương, duy trì 2 turn (Chỉ có hiệu quả khi chiến đấu)
                            new AE1433(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1435"://Mỗi lần chịu đòn trí mạng hồi phục 5% HP, mỗi trận tối đa kích hoạt 3 lần. (Chỉ có hiệu quả khi chiến đấu)
                            new PE1435(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "1436"://Vung Gậy Như Ý, gây cho địch ngẫu nhiên trong toàn màn hình 5 lần 100% sát thương phạm vi.
                            new AE1436(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "2436"://Vung Gậy Như Ý, gây cho địch ngẫu nhiên trong toàn màn hình 5 lần 60% sát thương phạm vi.
                            new AE1436(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        case "2438"://Mỗi lần dùng đạo cụ chiến đấu +1 ma pháp, mỗi turn tối đa +5 ma pháp.
                            new PE2438(coldDown, probability, gameType, skillId, delay, element).Start(this);
                            break;
                        #endregion
                        #region Kungfu Đại Sư
                        case "1542": //Mỗi turn sau khi bắn, pet sẽ có sác xuất 100% tấn công kẻ địch, tạo 30% sát thương

                            break;
                        case "1543": //Khi kết thúc turn, pet sẽ có sác xuất 100% tấn công kẻ địch, tạo 40% sát thương
                            break;
                        case "1544": //Khi kết thúc turn, pet sẽ có sác xuất 100% tấn công kẻ địch, tạo 50% sát thương
                            break;
                        #endregion
                        #region Kungfu Đại Hiệp
                        #endregion
                        #region Chuột Thợ Mỏ
                        #endregion
                        default:
                            Console.WriteLine(string.Format("Not Found element: {0}, Pet name: {1}", element,
                                m_pet.Name));
                            break;
                    }
                }
            }
        }

        public void InitFightBuffer(List<BufferInfo> buffers)
        {
            foreach (BufferInfo info in buffers)
            {
                switch (info.Type)
                {
                    case 101:
                        base.FightBuffers.ConsortionAddBloodGunCount = info.Value;
                        break;
                    case 102:
                        base.FightBuffers.ConsortionAddDamage = info.Value;
                        break;
                    case 103:
                        base.FightBuffers.ConsortionAddCritical = info.Value;
                        break;
                    case 104:
                        base.FightBuffers.ConsortionAddMaxBlood = info.Value;
                        break;
                    case 105:
                        base.FightBuffers.ConsortionAddProperty = info.Value;
                        break;
                    case 106:
                        base.FightBuffers.ConsortionReduceEnergyUse = info.Value;
                        break;
                    case 107:
                        base.FightBuffers.ConsortionAddEnergy = info.Value;
                        break;
                    case 108:
                        base.FightBuffers.ConsortionAddEffectTurn = info.Value;
                        break;
                    case 109:
                        base.FightBuffers.ConsortionAddOfferRate = info.Value;
                        break;
                    case 110:
                        base.FightBuffers.ConsortionAddPercentGoldOrGP = info.Value;
                        break;
                    case 111:
                        base.FightBuffers.ConsortionAddSpellCount = info.Value;
                        break;
                    case 112:
                        base.FightBuffers.ConsortionReduceDander = info.Value;
                        break;
                    case 400:
                        base.FightBuffers.WorldBossHP = info.Value;
                        break;
                    case 401:
                        base.FightBuffers.WorldBossAttrack = info.Value;
                        break;
                    case 402:
                        base.FightBuffers.WorldBossHP_MoneyBuff = info.Value;
                        break;
                    case 403:
                        base.FightBuffers.WorldBossAttrack_MoneyBuff = info.Value;
                        break;
                    case 404:
                        base.FightBuffers.WorldBossMetalSlug = info.Value;
                        break;
                    case 405:
                        base.FightBuffers.WorldBossAncientBlessings = info.Value;
                        break;
                    case 406:
                        base.FightBuffers.WorldBossAddDamage = info.Value;
                        break;
                }
            }
        }

        private bool CheckCondition(int condition)
        {
            if (base.Game is PVEGame)
            {
                PVEGame pve = base.Game as PVEGame;
                if (pve.Info.ID == 1 && (condition == 2 || condition == 3))
                {
                    return true;
                }
                if (pve.Info.ID == 2 && condition == 8)
                {
                    return true;
                }
                if (pve.Info.ID == 3 && (condition == 9 || condition == 10))
                {
                    return true;
                }
                if (pve.Info.ID == 4 && (condition == 4 || condition == 5))
                {
                    return true;
                }
                if (pve.Info.ID == 5 && (condition == 11 || condition == 12 || condition == 13))
                {
                    return true;
                }
                if (pve.Info.ID == 6 && (condition == 5 || condition == 16 || condition == 17))
                {
                    return true;
                }
                if (pve.Info.ID == 7 && (condition == 14 || condition == 15))
                {
                    return true;
                }
                if (pve.Info.ID == 11 && (condition == 7 || condition == 20))
                {
                    return true;
                }
                if (pve.Info.ID == 13 && (condition == 8 || condition == 21))
                {
                    return true;
                }
            }
            return base.Game is PVPGame;
        }

        public void InitCardBuffer(List<int> cards)
        {
            int minLv = 30;
            foreach (int card in cards)
            {
                if (card < 1100)
                {
                    minLv = card - 1000;
                }
            }
            int indexVal = 0;
            if (minLv >= 10)
            {
                indexVal = 1;
            }
            if (minLv >= 20)
            {
                indexVal = 2;
            }
            if (minLv >= 30)
            {
                indexVal = 3;
            }
            Dictionary<int, List<CardGroupInfo>> groups = CardBuffMgr.GetAllCard();
            List<CardBuffInfo> buffs = new List<CardBuffInfo>();
            int counter = 0;
            CardBuffInfo finalBuff = null;
            string msg = string.Empty;
            foreach (int key in groups.Keys)
            {
                counter = 0;
                foreach (CardGroupInfo card2 in groups[key])
                {
                    foreach (int id in cards)
                    {
                        if (id == card2.TemplateID)
                        {
                            counter++;
                        }
                    }
                }
                buffs = CardBuffMgr.FindCardBuffs(key);
                if (buffs == null)
                {
                    continue;
                }
                foreach (CardBuffInfo buff5 in buffs)
                {
                    if (counter >= buff5.Condition)
                    {
                        CardInfo cardNotice = CardBuffMgr.FindCard(key);
                        if (cardNotice != null && CheckCondition(buff5.PropertiesDscripID))
                        {
                            msg = "Kích hoạt <" + cardNotice.Name + "> hiệu ứng " + buff5.Condition + " thẻ!";
                            finalBuff = buff5;
                        }
                    }
                }
            }
            if (finalBuff == null)
            {
                return;
            }
            switch (finalBuff.CardID)
            {
                case 1:
                    new AntCaveEffect(indexVal, finalBuff).Start(this);
                    break;
                case 2:
                    if (finalBuff.Condition >= 4 && buffs != null)
                    {
                        foreach (CardBuffInfo buff in buffs)
                        {
                            if (buff.Condition >= 4)
                            {
                                new GuluKingdom4Effect(indexVal, buff).Start(this);
                            }
                            if (buff.Condition >= 2)
                            {
                                new GuluKingdom2Effect(indexVal, buff).Start(this);
                            }
                        }
                    }
                    if (finalBuff.Condition >= 2)
                    {
                        new GuluKingdom2Effect(indexVal, finalBuff).Start(this);
                    }
                    break;
                case 3:
                    if (finalBuff.Condition >= 5 && buffs != null)
                    {
                        foreach (CardBuffInfo buff2 in buffs)
                        {
                            if (buff2.Condition >= 5)
                            {
                                new EvilTribe5Effect(indexVal, buff2).Start(this);
                            }
                            if (buff2.Condition >= 3)
                            {
                                new EvilTribe3Effect(indexVal, buff2).Start(this);
                            }
                        }
                    }
                    if (finalBuff.Condition >= 3)
                    {
                        new EvilTribe3Effect(indexVal, finalBuff).Start(this);
                    }
                    break;
                case 4:
                    if (finalBuff.Condition >= 4 && buffs != null)
                    {
                        foreach (CardBuffInfo buff3 in buffs)
                        {
                            if (buff3.Condition >= 4)
                            {
                                new ShadowDevil4Effect(indexVal, buff3).Start(this);
                            }
                            if (buff3.Condition >= 2)
                            {
                                new ShadowDevil2Effect(indexVal, buff3).Start(this);
                            }
                        }
                    }
                    if (finalBuff.Condition >= 2)
                    {
                        new ShadowDevil2Effect(indexVal, finalBuff).Start(this);
                    }
                    break;
                case 5:
                    if (finalBuff.Condition >= 4)
                    {
                        foreach (CardBuffInfo buff4 in buffs)
                        {
                            if (buff4.Condition >= 4)
                            {
                                new FourArtifacts4Effect(indexVal, buff4).Start(this);
                            }
                            if (buff4.Condition >= 2)
                            {
                                new FourArtifacts2Effect(indexVal, buff4).Start(this);
                            }
                        }
                    }
                    if (finalBuff.Condition >= 2)
                    {
                        new FourArtifacts2Effect(indexVal, finalBuff).Start(this);
                    }
                    break;
                case 6:
                    if (finalBuff.Condition >= 5 && buffs != null)
                    {
                        foreach (CardBuffInfo buff7 in buffs)
                        {
                            if (buff7.Condition >= 5)
                            {
                                new Goblin5Effect(indexVal, buff7).Start(this);
                            }
                            if (buff7.Condition >= 4)
                            {
                                new Goblin4Effect(indexVal, buff7).Start(this);
                            }
                            if (buff7.Condition >= 2)
                            {
                                new Goblin2Effect(indexVal, buff7).Start(this);
                            }
                        }
                    }
                    if (finalBuff.Condition >= 4 && buffs != null)
                    {
                        foreach (CardBuffInfo buff6 in buffs)
                        {
                            if (buff6.Condition >= 4)
                            {
                                new Goblin4Effect(indexVal, buff6).Start(this);
                            }
                            if (buff6.Condition >= 2)
                            {
                                new Goblin2Effect(indexVal, buff6).Start(this);
                            }
                        }
                    }
                    if (finalBuff.Condition >= 2)
                    {
                        new Goblin2Effect(indexVal, finalBuff).Start(this);
                    }
                    break;
                case 7:
                    if (finalBuff.Condition >= 4 && buffs != null)
                    {
                        foreach (CardBuffInfo buff8 in buffs)
                        {
                            if (buff8.Condition >= 4)
                            {
                                new RunRunChicken4Effect(indexVal, buff8).Start(this);
                            }
                            if (buff8.Condition >= 2)
                            {
                                new RunRunChicken2Effect(indexVal, buff8).Start(this);
                            }
                        }
                    }
                    if (finalBuff.Condition >= 2)
                    {
                        new RunRunChicken2Effect(indexVal, finalBuff).Start(this);
                    }
                    break;
                case 8:
                    if (finalBuff.Condition >= 5 && buffs != null)
                    {
                        foreach (CardBuffInfo buff10 in buffs)
                        {
                            if (buff10.Condition >= 5)
                            {
                                new GuluSportsMeeting5Effect(indexVal, buff10).Start(this);
                            }
                            if (buff10.Condition >= 4)
                            {
                                new GuluSportsMeeting4Effect(indexVal, buff10).Start(this);
                            }
                            if (buff10.Condition >= 2)
                            {
                                new GuluSportsMeeting2Effect(indexVal, buff10).Start(this);
                            }
                        }
                    }
                    if (finalBuff.Condition >= 4 && buffs != null)
                    {
                        foreach (CardBuffInfo buff9 in buffs)
                        {
                            if (buff9.Condition >= 4)
                            {
                                new GuluSportsMeeting4Effect(indexVal, buff9).Start(this);
                            }
                            if (buff9.Condition >= 2)
                            {
                                new GuluSportsMeeting2Effect(indexVal, buff9).Start(this);
                            }
                        }
                    }
                    if (finalBuff.Condition >= 2)
                    {
                        new GuluSportsMeeting2Effect(indexVal, finalBuff).Start(this);
                    }
                    break;
                case 9:
                    if (finalBuff.Condition >= 5 && buffs != null)
                    {
                        foreach (CardBuffInfo buff11 in buffs)
                        {
                            if (buff11.Condition >= 5)
                            {
                                new FiveGodSoldier5Effect(indexVal, buff11).Start(this);
                            }
                            if (buff11.Condition >= 2)
                            {
                                new FiveGodSoldier2Effect(indexVal, buff11).Start(this);
                            }
                        }
                    }
                    if (finalBuff.Condition >= 2)
                    {
                        new FiveGodSoldier2Effect(indexVal, finalBuff).Start(this);
                    }
                    break;
                case 10:
                    if (finalBuff.Condition >= 5 && buffs != null)
                    {
                        foreach (CardBuffInfo buff12 in buffs)
                        {
                            if (buff12.Condition >= 5)
                            {
                                new TimeVortex5Effect(indexVal, buff12).Start(this);
                            }
                            if (buff12.Condition >= 3)
                            {
                                new TimeVortex3Effect(indexVal, buff12).Start(this);
                            }
                        }
                    }
                    if (finalBuff.Condition >= 3)
                    {
                        new TimeVortex3Effect(indexVal, finalBuff).Start(this);
                    }
                    break;
                case 11:
                    if (finalBuff.Condition >= 5 && buffs != null)
                    {
                        foreach (CardBuffInfo buff13 in buffs)
                        {
                            if (buff13.Condition >= 5)
                            {
                                new WarriorsArena5Effect(indexVal, buff13).Start(this);
                            }
                            if (buff13.Condition >= 3)
                            {
                                new WarriorsArena3Effect(indexVal, buff13).Start(this);
                            }
                        }
                    }
                    if (finalBuff.Condition >= 3)
                    {
                        new WarriorsArena3Effect(indexVal, finalBuff).Start(this);
                    }
                    break;
                case 12:
                    new PioneerEffect(indexVal, finalBuff).Start(this);
                    break;
                case 13:
                    new WeaponMasterEffect(indexVal, finalBuff).Start(this);
                    break;
                case 14:
                    new DivineEffect(indexVal, finalBuff).Start(this);
                    break;
                case 15:
                    new LuckyEffect(indexVal, finalBuff).Start(this);
                    break;
            }
            if (!string.IsNullOrEmpty(msg))
            {
                if (base.Game is PVEGame)
                {
                    m_player.SendMessage(msg);
                }
                else
                {
                    PlayerDetail.SendMessage(msg);
                }
            }

        }

        public bool IsCure()
        {
            switch (Weapon.TemplateID)
            {
                case 17000:
                case 17001:
                case 17002:
                case 17005:
                case 17007:
                case 17010:
                case 17100:
                case 17102:
                    return true;
                default:
                    return false;
            }
        }

        public void CalculatePlayerOffer(Player player)
        {
            if (m_game.RoomType == eRoomType.Match && (m_game.GameType == eGameType.Guild || m_game.GameType == eGameType.Free) && !player.IsLiving)
            {
                int robOffer = ((base.Game.GameType == eGameType.Guild) ? 10 : ((PlayerDetail.PlayerCharacter.ConsortiaID == 0 || player.PlayerDetail.PlayerCharacter.ConsortiaID == 0) ? 1 : 3));
                if (robOffer > player.PlayerDetail.PlayerCharacter.Offer)
                {
                    robOffer = player.PlayerDetail.PlayerCharacter.Offer;
                }
                robOffer += TotalHurt / 2000;
                if (robOffer > 0)
                {
                    GainOffer += robOffer;
                    player.KilledPunishmentOffer = robOffer;
                }
            }
        }

        public override void OnAfterKillingLiving(Living target, int damageAmount, int criticalAmount)
        {
            base.OnAfterKillingLiving(target, damageAmount, criticalAmount);
            if (target is Player)
            {
                m_player.OnKillingLiving(m_game, 1, target.Id, target.IsLiving, damageAmount + criticalAmount);
                CalculatePlayerOffer(target as Player);
                return;
            }
            int id = 0;
            if (target is SimpleBoss)
            {
                id = (target as SimpleBoss).NpcInfo.ID;
            }
            if (target is SimpleNpc)
            {
                id = (target as SimpleNpc).NpcInfo.ID;
            }
            m_player.OnKillingLiving(m_game, 2, id, target.IsLiving, damageAmount + criticalAmount);
        }

        protected void OnAfterPlayerShoot()
        {
            m_useitemCount = 9999;
            if (this.AfterPlayerShooted != null)
            {
                this.AfterPlayerShooted(this);
            }
        }

        protected void OnBeforePlayerShoot()
        {
            if (this.BeforePlayerShoot != null)
            {
                this.BeforePlayerShoot(this);
            }
        }

        protected void OnCollidedByObject()
        {
            if (this.CollidByObject != null)
            {
                this.CollidByObject(this);
            }
        }

        protected void OnLoadingCompleted()
        {
            if (this.LoadingCompleted != null)
            {
                this.LoadingCompleted(this);
            }
        }

        public void OnPlayerBuffSkillPet()
        {
            if (this.PlayerBuffSkillPet != null)
            {
                this.PlayerBuffSkillPet(this);
            }
        }

        public void OnPlayerClearBuffSkillPet()
        {
            if (this.PlayerClearBuffSkillPet != null)
            {
                this.PlayerClearBuffSkillPet(this);
            }
        }

        public void OnPlayerCure()
        {
            if (this.PlayerCure != null)
            {
                this.PlayerCure(this);
            }
        }

        public void OnPlayerGuard()
        {
            if (this.PlayerGuard != null)
            {
                this.PlayerGuard(this);
            }
        }

        public void OnPlayerShootCure()
        {
            if (this.PlayerShootCure != null)
            {
                this.PlayerShootCure(this);
            }
        }

        protected void OnPlayerMoving()
        {
            if (this.PlayerBeginMoving != null)
            {
                this.PlayerBeginMoving(this);
            }
        }

        public void OnPlayerShoot()
        {
            if (this.PlayerShoot != null)
            {
                this.PlayerShoot(this);
            }
        }

        protected void OnPlayerCompleteShoot()
        {
            if (this.PlayerCompleteShoot != null)
            {
                this.PlayerCompleteShoot(this);
            }
        }

        public void OnPlayerAnyShellThrow()
        {
            if (this.PlayerAnyShellThrow != null)
            {
                this.PlayerAnyShellThrow(this);
            }
        }

        public event PlayerEventHandle PlayerAfterBuffSkillPet;

        public void OnPlayerAfterBuffSkillPet()
        {
            PlayerAfterBuffSkillPet?.Invoke(this);
        }

        public void OnPlayerUseSecondWeapon(int type)
        {
            if (this.PlayerUseSecondWeapon != null)
            {
                this.PlayerUseSecondWeapon(this, type);
            }
        }

        public void OnPlayerBeforeReset()
        {
            this.PlayerBeforeReset?.Invoke(this);
        }

        public void OnPlayerAfterReset()
        {
            this.PlayerAfterReset?.Invoke(this);
        }

        public void OpenBox(int boxId)
        {
            Box box = null;
            foreach (Box box2 in m_tempBoxes)
            {
                if (box2.Id == boxId)
                {
                    box = box2;
                    break;
                }
            }
            if (box == null || box.Item == null)
            {
                return;
            }
            ItemInfo item = box.Item;
            switch (item.TemplateID)
            {
                case -1100:
                    m_player.AddGiftToken(item.Count);
                    break;
                case -800:
                    m_player.AddHonor(item.Count);
                    break;
                case -200:
                    m_player.AddMoney(item.Count, igroneAll: false);
                    m_player.LogAddMoney(AddMoneyType.Box, AddMoneyType.Box_Open, m_player.PlayerCharacter.ID, item.Count, m_player.PlayerCharacter.Money);
                    break;
                case -100:
                    m_player.AddGold(item.Count);
                    break;
                default:
                    if (item.Template.CategoryID == 10)
                    {
                        if (!m_player.AddTemplate(item, eBageType.FightBag, item.Count, eGameView.RouletteTypeGet))
                        {
                        }
                    }
                    else
                    {
                        m_player.AddTemplate(item, eBageType.TempBag, item.Count, eGameView.dungeonTypeGet);
                    }
                    break;
            }
            m_tempBoxes.Remove(box);
        }

        public override void PickBox(Box box)
        {
            m_tempBoxes.Add(box);
            base.PickBox(box);
        }

        public override void PrepareNewTurn()
        {
            ItemFightBag.Clear();
            if (CurrentIsHitTarget)
            {
                TotalHitTargetCount++;
            }
            m_energy = (int)Agility / 30 + 240;
            //m_useitemCount = 0;
            if (base.FightBuffers.ConsortionAddEnergy > 0)
            {
                m_energy += base.FightBuffers.ConsortionAddEnergy;
            }
            base.PetEffects.CurrentUseSkill = 0;
            base.PetEffects.PetDelay = 0;
            base.SpecialSkillDelay = 0;
            PetEffectTrigger = false;
            base.SpecialSkillDelay = 0;
            m_shootCount = 1;
            m_ballCount = 1;
            AttackInformation = true;
            DefenceInformation = true;
            EffectTrigger = false;
            PetEffectTrigger = false;
            PetEffects.DisibleActiveSkill = false;
            m_flyCoolDown--;
            SetCurrentWeapon(PlayerDetail.MainWeapon);
            if (m_currentBall.ID != m_mainBallId)
            {
                m_currentBall = BallMgr.FindBall(m_mainBallId);
            }
            if (!base.IsLiving)
            {
                StartGhostMoving();
                TargetPoint = Point.Empty;
            }
            if (!base.PetEffects.StopMoving)
            {
                base.SpeedMultX(3);
            }
            CanFly = true;
            base.PrepareNewTurn();
        }

        public override void PrepareSelfTurn()
        {
            base.PrepareSelfTurn();
            m_useitemCount = 0;
            DefaultDelay = m_delay;
            m_flyCoolDown--;
            m_game.SendRoundOneEnd(this);
            if (m_pet == null)
            {
                return;
            }
            foreach (int skillId in _petSkillCd.Keys)
            {
                if (_petSkillCd[skillId].Turn > 0)
                {
                    _petSkillCd[skillId].Turn--;
                }
            }
        }

        public void PrepareShoot(byte speedTime)
        {
            int turnWaitTime = m_game.GetTurnWaitTime();
            int num2 = ((speedTime > turnWaitTime) ? turnWaitTime : speedTime);
            AddDelay(num2 * 20);
            TotalShootCount++;
        }

        public bool ReduceEnergy(int value)
        {
            if (value > m_energy)
            {
                value = m_energy;
            }
            m_energy -= value;
            return true;
        }

        public void ResetSkillCd()
        {
            if (m_pet == null)
            {
                return;
            }
            string[] listSkills = m_pet.SkillEquip.Split('|');
            string[] array = listSkills;
            foreach (string skill in array)
            {
                int skillId = int.Parse(skill.Split(',')[0]);
                if (_petSkillCd.ContainsKey(skillId))
                {
                    _petSkillCd[skillId].Turn = _petSkillCd[skillId].ColdDown;
                }
            }
        }

        public override void Reset()
        {
            if (m_game.RoomType == eRoomType.Dungeon)
            {
                m_game.Cards = new int[21];
            }
            else
            {
                m_game.Cards = new int[9];
            }
            base.EffectList.StopAllEffect();
            base.CardEffectList.StopAllEffect();
            base.Dander = 0;
            //base.PetMP = 0;
            base.PetMP = 10;
            base.psychic = 00;
            base.IsLiving = true;
            FinishTakeCard = false;
            if (base.AutoBoot)
            {
                base.VaneOpen = true;
            }
            else
            {
                base.VaneOpen = m_player.PlayerCharacter.Grade >= 9;
            }
            InitFightBuffer(m_player.FightBuffs);
            InitCardBuffer(PlayerDetail.CardBuff);
            m_Healstone = m_player.Healstone;
            m_changeSpecialball = 0;
            m_DeputyWeapon = m_player.SecondWeapon;
            m_weapon = m_player.MainWeapon;
            BallConfigInfo info = BallConfigMgr.FindBall(m_weapon.TemplateID);
            m_mainBallId = info.Common;
            m_spBallId = info.Special;
            m_AddWoundBallId = info.CommonAddWound;
            m_MultiBallId = info.CommonMultiBall;
            BaseDamage = m_player.GetBaseAttack();
            BaseGuard = m_player.GetBaseDefence();
            Attack = m_player.PlayerCharacter.Attack;
            Defence = m_player.PlayerCharacter.Defence;
            Agility = m_player.PlayerCharacter.Agility;
            Lucky = m_player.PlayerCharacter.Luck;
            m_maxBlood = m_player.PlayerCharacter.hp;
            BaseDamage += m_player.PlayerCharacter.DameAddPlus;
            OnPlayerBeforeReset();
            if (base.FightBuffers.ConsortionAddDamage > 0)
            {
                BaseDamage += base.FightBuffers.ConsortionAddDamage;
            }
            BaseGuard += m_player.PlayerCharacter.GuardAddPlus;
            Attack += m_player.PlayerCharacter.AttackAddPlus;
            Defence += m_player.PlayerCharacter.DefendAddPlus;
            Agility += m_player.PlayerCharacter.AgiAddPlus;
            Lucky += m_player.PlayerCharacter.LuckAddPlus;
            Attack += m_player.PlayerCharacter.StrengthEnchance;
            Defence += m_player.PlayerCharacter.StrengthEnchance;
            Agility += m_player.PlayerCharacter.StrengthEnchance;
            Lucky += m_player.PlayerCharacter.StrengthEnchance;
            if (base.FightBuffers.ConsortionAddMaxBlood > 0)
            {
                m_maxBlood += m_maxBlood * base.FightBuffers.ConsortionAddMaxBlood / 100;
            }
            m_maxBlood += m_player.PlayerCharacter.HpAddPlus + base.PetEffects.MaxBlood + FightBuffers.WorldBossHP;
            if (m_bufferPoint != null)
            {
                Attack += Attack / 100.0 * (double)m_bufferPoint.Value;
                Defence += Defence / 100.0 * (double)m_bufferPoint.Value;
                Agility += Agility / 100.0 * (double)m_bufferPoint.Value;
                Lucky += Lucky / 100.0 * (double)m_bufferPoint.Value;
            }
            if (base.FightBuffers.ConsortionAddProperty > 0)
            {
                Attack += base.FightBuffers.ConsortionAddProperty;
                Defence += base.FightBuffers.ConsortionAddProperty;
                Agility += base.FightBuffers.ConsortionAddProperty;
                Lucky += base.FightBuffers.ConsortionAddProperty;
            }
            m_energy = (int)Agility / 30 + 240;
            m_useitemCount = 0;
            if (base.FightBuffers.ConsortionAddEnergy > 0)
            {
                m_energy += base.FightBuffers.ConsortionAddEnergy;
            }
            if (petFightPropertyInfo != null)
            {
                Attack += petFightPropertyInfo.Attack;
                Defence += petFightPropertyInfo.Defence;
                Agility += petFightPropertyInfo.Agility;
                Lucky += petFightPropertyInfo.Lucky;
                m_maxBlood += petFightPropertyInfo.Blood;
            }
            m_maxBlood += PetEffects == null ? 0 : PetEffects.AddMaxBloodValue;
            m_currentBall = BallMgr.FindBall(m_mainBallId);
            m_shootCount = 1;
            m_ballCount = 1;
            CurrentIsHitTarget = false;
            LimitEnergy = false;
            TotalCure = 0;
            TotalHitTargetCount = 0;
            TotalHurt = 0;
            TotalKill = 0;
            TotalShootCount = 0;
            LockDirection = false;
            GainGP = 0;
            GainOffer = 0;
            Ready = false;
            PlayerDetail.ClearTempBag();
            LoadingProcess = 0;
            base.PetEffects.CritRate = 0;
            m_killedPunishmentOffer = 0;
            m_prop = 0;
            InitBuffer(m_player.EquipEffect);
            CanFly = true;
            if (m_DeputyWeapon != null)
            {
                deputyWeaponResCount = m_DeputyWeapon.StrengthenLevel + 1;
            }
            else
            {
                deputyWeaponResCount = 1;
            }
            ResetSkillCd();
            OnPlayerAfterReset();
            m_powerRatio = 100;
            m_isBombOrIgnoreArmor = 0;
            m_playerConfig = new PlayerConfig();
            base.Reset();
        }

        public virtual int AddMaxBlood(int value)
        {
            if (value != 0)
            {
                base.MaxBlood += value;
            }
            return value;
        }

        public void SetBall(int ballId)
        {
            SetBall(ballId, special: false);
        }

        public void SetBall(int ballId, bool special)
        {
            if (ballId != m_currentBall.ID)
            {
                if (BallMgr.FindBall(ballId) != null)
                {
                    m_currentBall = BallMgr.FindBall(ballId);
                }
                m_game.SendGameUpdateBall(this, special);
            }
        }

        public void SetCurrentWeapon(ItemInfo item)
        {
            m_weapon = item;
            BallConfigInfo info = BallConfigMgr.FindBall(m_weapon.TemplateID);
            if (m_weapon.isGold)
            {
                info = BallConfigMgr.FindBall(m_weapon.GoldEquip.TemplateID);
            }
            if (ChangeSpecialBall > 0)
            {
                info = BallConfigMgr.FindBall(70396);
            }
            m_mainBallId = info.Common;
            m_spBallId = info.Special;
            m_AddWoundBallId = info.CommonAddWound;
            m_MultiBallId = info.CommonMultiBall;
            SetBall(m_mainBallId);
        }

        public override void SetXY(int x, int y)
        {
            if (m_x == x && m_y == y)
            {
                return;
            }
            int value = Math.Abs(m_x - x);
            m_x = x;
            m_y = y;
            if (base.IsLiving && !LimitEnergy)
            {
                m_energy -= Math.Abs(m_x - x);
                if (value > 0)
                {
                    OnPlayerMoving();
                }
                return;
            }
            Rectangle rect = m_rect;
            rect.Offset(m_x, m_y);
            Physics[] array = m_map.FindPhysicalObjects(rect, this);
            Physics[] array2 = array;
            Physics[] array3 = array2;
            foreach (Physics physics in array3)
            {
                if (physics is Box)
                {
                    Box box = physics as Box;
                    PickBox(box);
                    base.Game.CheckBox();
                }
            }
        }

        public bool Shoot(int x, int y, int force, int angle)
        {
            if (m_game.FreeFatal && PlayerDetail.PlayerCharacter.Grade <= 15)
            {
                new FatalEffect(0, 15112004).Start(this);
            }
            if (m_shootCount == 1)
            {
                base.PetEffects.ActivePetHit = true;
            }
            if (m_shootCount > 0)
            {
                EffectTrigger = false;
                OnPlayerShoot();
                int iD = m_currentBall.ID;
                if (m_ballCount == 1 && !IsSpecialSkill && m_isBombOrIgnoreArmor == 0)
                {
                    if (Prop == 20002)
                    {
                        iD = m_MultiBallId;
                    }
                    if (Prop == 20008)
                    {
                        iD = m_AddWoundBallId;
                    }
                }
                OnPlayerAnyShellThrow();
                OnBeforePlayerShoot();
                if (IsSpecialSkill)
                {
                    ControlBall = false;
                    base.SpecialSkillDelay = 2000;
                }
                //quydeptrai
                int tmpID = iD;
                if (m_isBombOrIgnoreArmor > 0)
                {
                    if (m_isBombOrIgnoreArmor == 1)//xuyên
                    {
                        IgnoreArmor = true;
                    }
                    else if (m_isBombOrIgnoreArmor == 2)//hạt nhân
                    {
                        iD = 4;
                    }
                }

                //ts
                if (BallMgr.GetBallType(iD) == BombType.CURE)
                {
                    m_ballCount = 1;
                    ShootCount = 1;
                }
                //
                //
                if (ShootImp(iD, x, y, force, angle, m_ballCount, ShootCount))
                {
                    if (iD == 4)
                    {
                        m_game.AddAction(new FightAchievementAction(this, eFightAchievementType.SuperMansNuclearExplosion, base.Direction, 1200));
                    }
                    //quydeptrai
                    if (m_isBombOrIgnoreArmor > 0)
                    {
                        if (m_isBombOrIgnoreArmor == 1)//xuyên
                        {
                            IgnoreArmor = false;
                        }
                        else if (m_isBombOrIgnoreArmor == 2)//hạt nhân
                        {
                            iD = tmpID;
                        }
                        m_isBombOrIgnoreArmor = 0;
                    }
                    //
                    m_shootCount--;
                    if (m_shootCount <= 0 || !base.IsLiving)
                    {
                        StopAttacking();
                        AddDelay(m_currentBall.Delay + (m_weapon.isGold ? m_weapon.GoldEquip.Property8 : m_weapon.Template.Property8));
                        AddDander(20);
                        AddPetMP(10);
                        m_prop = 0;
                        if (CanGetProp)
                        {
                            int gold = 0;
                            int money = 0;
                            int giftToken = 0;
                            int medal = 0;
                            int honor = 0;
                            int hardCurrency = 0;
                            int token = 0;
                            int dragonToken = 0;
                            int magicStonePoint = 0;
                            List<ItemInfo> list = null;
                            if (DropInventory.FireDrop(m_game.RoomType, ref list) && list != null)
                            {
                                foreach (ItemInfo info in list)
                                {
                                    ShopMgr.FindSpecialItemInfo(info, ref gold, ref money, ref giftToken, ref medal, ref honor, ref hardCurrency, ref token, ref dragonToken, ref magicStonePoint);
                                    if (info == null || !base.VaneOpen || info.TemplateID <= 0)
                                    {
                                        continue;
                                    }
                                    if (info.Template.CategoryID == 10)
                                    {
                                        if (!PlayerDetail.AddTemplate(info, eBageType.FightBag, info.Count, eGameView.RouletteTypeGet))
                                        {
                                        }
                                    }
                                    else
                                    {
                                        PlayerDetail.AddTemplate(info, eBageType.TempBag, info.Count, eGameView.dungeonTypeGet);
                                    }
                                }
                                PlayerDetail.AddGold(gold);
                                PlayerDetail.AddMoney(money, igroneAll: false);
                                PlayerDetail.LogAddMoney(AddMoneyType.Game, AddMoneyType.Game_Shoot, PlayerDetail.PlayerCharacter.ID, money, PlayerDetail.PlayerCharacter.Money);
                                PlayerDetail.AddGiftToken(giftToken);
                                PlayerDetail.AddHonor(honor);
                            }
                        }
                        OnPlayerCompleteShoot();
                    }
                    //SendAttackInformation();
                    OnAfterPlayerShoot();
                    return true;
                }
            }
            return false;
        }

        public override void Skip(int spendTime)
        {
            if (base.IsAttacking)
            {
                base.Game.SendSkipNext(this);
                m_prop = 0;
                AddDelay(100);
                AddDander(20);
                AddPetMP(10);
                OnPlayerSkip();
                base.Skip(spendTime);
            }
        }

        public void PetUseKill(int skillId, int type)
        {
            //Console.WriteLine("PetUseKill skillID:{0}, type:{1}", skillId, type);
            if (CanUseSkill(skillId) && PetSkillCD.ContainsKey(skillId) && !PetEffects.DisibleActiveSkill)
            {
                PetSkillInfo skillInfo = _petSkillCd[skillId];
                if (skillInfo.NewBallID != -1 && m_useitemCount > 0)
                {
                    m_player.SendMessage("Không thể sử dụng kỹ năng pet.");
                    return;
                }
                if (PetMP > 0 && PetMP >= skillInfo.CostMP)
                {
                    if (skillInfo.Turn > 0)
                    {
                        m_player.SendMessage(LanguageMgr.GetTranslation("Player.Msg1a"));
                    }
                    else
                    {
                        m_useitemCount = 9999;
                        if (skillInfo.NewBallID != -1)
                        {
                            PetEffects.Delay += skillInfo.Delay;
                            SetBall(skillInfo.NewBallID);
                        }
                        PetMP -= skillInfo.CostMP;

                        PetEffects.CurrentUseSkill = skillId;
                        PetEffects.BallType = skillInfo.BallType;
                        m_game.SendPetUseKill(this, type);

                        OnPlayerBuffSkillPet();

                        skillInfo.Turn = skillInfo.ColdDown + 1;
                        OnPlayerAfterBuffSkillPet();
                    }
                }
                else
                {
                    m_player.SendMessage(LanguageMgr.GetTranslation("Player.Msg1"));
                }
            }
        }

        public bool CanUseSkill(int Id)
        {
            if (m_useitemCount >= 999)
            {
                return false;
            }
            if (m_pet != null)
            {
                string[] array = m_pet.SkillEquip.Split('|');
                for (int i = 0; i < array.Length; i++)
                {
                    if (int.Parse(array[i].Split(',')[0]) == Id)
                    {
                        return true;
                    }
                }
            }
            return false;
        }

        public override void StartAttacking()
        {
            if (base.IsAttacking)
            {
                return;
            }
            if (m_Healstone != null && m_blood < m_maxBlood && !base.Game.IsSpecialPVE() && m_player.RemoveHealstone())
            {
                int property2 = m_Healstone.Template.Property2;
                BufferInfo fightBuffByType = GetFightBuffByType(BuffType.ReHealth);
                if (fightBuffByType != null && m_player.UsePayBuff(BuffType.ReHealth))
                {
                    property2 *= fightBuffByType.Value;
                }
                AddBlood(property2);
            }
            AddDelay(GetTurnDelay());
            base.StartAttacking();
        }

        public BufferInfo GetFightBuffByType(BuffType buff)
        {
            foreach (BufferInfo fightBuff in m_player.FightBuffs)
            {
                if (fightBuff.Type == (int)buff)
                {
                    return fightBuff;
                }
            }
            return null;
        }

        public void SendAttackInformation()
        {
            if (EffectTrigger && AttackInformation)
            {
                EffectTrigger = false;
                AttackInformation = false;
            }
        }

        public void StartGhostMoving()
        {
            if (!TargetPoint.IsEmpty)
            {
                Point point = new Point(TargetPoint.X - X, TargetPoint.Y - Y);
                if (point.Length() > 160.0)
                {
                    point.Normalize(160);
                }
                m_game.AddAction(new GhostMoveAction(this, new Point(X + point.X, Y + point.Y)));
            }
        }

        public override void StartMoving()
        {
            if (m_map == null)
            {
                return;
            }
            Point point = m_map.FindYLineNotEmptyPointDown(m_x, m_y);
            if (point.IsEmpty)
            {
                if (m_map.Ground != null)
                {
                    m_y = m_map.Ground.Height;
                }
            }
            else
            {
                m_x = point.X;
                m_y = point.Y;
            }
            if (point.IsEmpty)
            {
                m_syncAtTime = false;
                Die();
            }
        }

        public override void StartMoving(int delay, int speed)
        {
            if (m_map != null)
            {
                Point point = m_map.FindYLineNotEmptyPointDown(m_x, m_y);
                if (point.IsEmpty)
                {
                    m_y = m_map.Ground.Height;
                }
                else
                {
                    m_x = point.X;
                    m_y = point.Y;
                }
                base.StartMoving(delay, speed);
                if (point.IsEmpty)
                {
                    m_syncAtTime = false;
                    Die();
                }
            }
        }

        public void StartSpeedMult(int x, int y, int delay)
        {
            Point point = new Point(x - X, y - Y);
            m_game.AddAction(new PlayerSpeedMultAction(this, new Point(X + point.X, Y + point.Y), delay));
        }

        public override bool TakeDamage(Living source, ref int damageAmount, ref int criticalAmount, string msg)
        {
            if ((source == this || source.Team == base.Team) && damageAmount + criticalAmount >= m_blood)
            {
                damageAmount = m_blood - 1;
                criticalAmount = 0;
            }
            bool flag = base.TakeDamage(source, ref damageAmount, ref criticalAmount, msg);
            if (base.IsLiving)
            {
                AddDander((damageAmount * 2 / 5 + 5) / 2);
                if (!base.Game.IsSpecialPVE() && base.Blood < base.MaxBlood / 100 * 30)
                {
                    BufferInfo fightBuffByType = GetFightBuffByType(BuffType.Save_Life);
                    if (fightBuffByType != null && m_player.UsePayBuff(BuffType.Save_Life))
                    {
                        int num = base.MaxBlood / 100 * fightBuffByType.Value;
                        AddBlood(num);
                        m_game.method_53(this, LanguageMgr.GetTranslation("GameServer.PayBuff.ReLife.UseNotice", PlayerDetail.PlayerCharacter.NickName, num));
                    }
                }
            }
            return flag;
        }

        public void UseFlySkill()
        {
            if (CanFly)
            {
                m_useitemCount += 1;
                m_game.SendPlayerUseProp(this, -2, -2, CARRY_TEMPLATE_ID);
                SetBall(3);
            }
        }



        public bool UseItem(ItemTemplateInfo item)
        {
            m_useitemCount += 1;
            if (CanUseItem(item))
            {
                m_energy -= item.Property4;
                m_delay += item.Property5;
                m_game.SendPlayerUseProp(this, -2, -2, item.TemplateID, this);
                SpellMgr.ExecuteSpell(m_game, m_game.CurrentLiving as Player, item);
                return true;
            }
            return false;
        }

        public bool UseItem(ItemTemplateInfo item, int place)
        {
            if (!CanUseItem(item, place))
            {
                return false;
            }
            if (base.IsLiving)
            {
                ReduceEnergy(item.Property4);
                AddDelay(item.Property5);
            }
            else if (place == -1)
            {
                base.psychic -= item.Property7;
                base.Game.CurrentLiving.AddDelay(item.Property5);
            }
            m_game.method_39(this, -2, -2, item.TemplateID);
            SpellMgr.ExecuteSpell(m_game, m_game.CurrentLiving as Player, item);
            if (item.Property6 == 1 && base.IsAttacking)
            {
                StopAttacking();
                m_game.CheckState(0);
            }
            m_useitemCount += 1;
            OnBeginUseProp();
            return true;
        }

        public void UseSecondWeapon()
        {
            m_useitemCount += 1;
            if (!CanUseItem(m_DeputyWeapon.Template))
            {
                return;
            }
            if (m_DeputyWeapon.Template.Property3 == 31)
            {
                bool isArrmor = false;
                if (new List<int>
                {
                    17006,
                    17012,
                    17013
                }.Contains(m_DeputyWeapon.TemplateID))
                {
                    isArrmor = true;
                }
                new AddGuardEquipEffect((int)getHertAddition(m_DeputyWeapon), 1, isArrmor).Start(this);
                OnPlayerGuard();
            }
            else
            {
                SetCurrentWeapon(m_DeputyWeapon);
                OnPlayerCure();
            }
            ShootCount = 1;
            m_energy -= m_DeputyWeapon.Template.Property4;
            m_delay += m_DeputyWeapon.Template.Property5;
            m_game.SendPlayerUseProp(this, -2, -2, m_DeputyWeapon.Template.TemplateID);
            if (deputyWeaponResCount > 0)
            {
                deputyWeaponResCount--;
                m_game.SendUseDeputyWeapon(this, deputyWeaponResCount);
            }
            OnPlayerUseSecondWeapon(m_DeputyWeapon.Template.Property3);
        }

        public void UseSpecialSkill()
        {
            if (m_useitemCount <= 15)
            {
                m_useitemCount = 9999;
                if (base.Dander >= 200)
                {
                    SetBall(m_spBallId, special: true);
                    m_ballCount = m_currentBall.Amount;
                    SetDander(0);
                }
            }
        }

        public override void SpeedMultX(int value)
        {
            SpeedMult = value;
            MOVE_SPEED = value - 1;
            base.SpeedMultX(value);
        }

        public bool canMoveDirection(int dir)
        {
            return !m_map.IsOutMap(X + (15 + MOVE_SPEED) * dir, Y);
        }

        public Point getNextWalkPoint(int dir)
        {
            if (canMoveDirection(dir))
            {
                return m_map.FindNextWalkPoint(X, Y, dir, StepX, StepY);
            }
            return Point.Empty;
        }

        public Point FindYLineNotEmptyPointDown(int tx, int ty)
        {
            _ = m_map.Bound;
            return m_map.FindYLineNotEmptyPointDown(tx, ty, m_map.Bound.Height);
        }

        public void OnBeforeBomb(int delay)
        {
            if (this.BeforeBomb != null)
            {
                this.BeforeBomb(this);
            }
        }

        public void SkipAttack()
        {
            m_useitemCount = 9999;
            Game.SendSkipNext(this);
            m_prop = 0;
            AddDelay(100);
            base.Skip(1000);
        }

        public void MarkMeHide(bool isMark)
        {
            m_game.SendMarkMeHideInfo(this, Id, isMark);
        }

        private List<int> propsBloqueados;

        public void unlockProp(int templateid)
        {
            propsBloqueados.Remove(templateid);
        }

        public void lockProp(int templateid)
        {
            if (propsBloqueados.Contains(templateid))
            {
                return;
            }

            propsBloqueados.Add(templateid);
        }

        public void SendPicturePlayer(int type, bool state, int count)
        {
            if (m_syncAtTime)
            {
                m_game.updatePlayerBuff(this, type, state, count);
            }
        }
        public Point StartFalling(bool direct)
        {
            return this.StartFalling(direct, 0, Living.MOVE_SPEED * 10);
        }
        public virtual Point StartFalling(bool direct, int delay, int speed)
        {
            Point p = this.m_map.FindYLineNotEmptyPointDown(this.X, this.Y);
            if (p == Point.Empty)
            {
                p = new Point(this.X, this.m_game.Map.Bound.Height + 1);
            }
            if (p.Y == this.Y)
            {
                return Point.Empty;
            }
            if (direct)
            {
                base.SetXY(p);
                if (this.m_map.IsOutMap(p.X, p.Y))
                {
                    base.Die();
                }
            }
            else
            {
                this.m_game.AddAction(new LivingFallingAction(this, p.X, p.Y, speed, null, delay, 0, null));
            }
            return p;
        }
    }
}
