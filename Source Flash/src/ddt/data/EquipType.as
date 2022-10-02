package ddt.data
{
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   
   public class EquipType
   {
      
      public static const T_SBUGLE:int = 11101;
      
      public static const T_BBUGLE:int = 11102;
      
      public static const T_CBUGLE:int = 11100;
      
      public static const EASY_TICKET_ID:int = 200619;
      
      public static const NORMAL_TICKET_ID:int = 200620;
      
      public static const HARD_TICKET_ID:int = 200621;
      
      public static const HERO_TICKET_ID:int = 200622;
      
      public static const EPIC_TICKET_ID:int = 201105;
      
      public static const FOOTBALL_NORMAL_TICKET_ID:int = 201279;
      
      public static const FOOTBALL_HARD_TICKET_ID:int = 201280;
      
      public static const FOOTBALL_HERO_TICKET_ID:int = 201281;
      
      public static const T_ALL_PROP:int = 10200;
      
      public static const COLORCARD:int = 11999;
      
      public static const REWORK_NAME:int = 11994;
      
      public static const WISHBEAD_ATTACK:int = 11560;
      
      public static const WISHBEAD_DEFENSE:int = 11561;
      
      public static const WISHBEAD_AGILE:int = 11562;
      
      public static const CONSORTIA_REWORK_NAME:int = 11993;
      
      public static const CHANGE_SEX:int = 11569;
      
      public static const VIPCARD:int = 11992;
      
      public static const VIPCARD_TEST:int = 11991;
      
      public static const TRANSFER_PROP:int = 34101;
      
      public static const CHANGE_COLOR_SHELL:int = 11999;
      
      public static const MEDAL:int = 11408;
      
      public static const GIFT:int = -300;
      
      public static const EXP:int = 11107;
      
      public static const GOLD_BOX:int = 11233;
      
      public static const ROULETTE_BOX:int = 112019;
      
      public static const VIP_COIN:int = 112109;
      
      public static const ROULETTE_KEY:int = 11444;
      
      public static const SURPRISE_ROULETTE_BOX:int = 190000;
      
      public static const SURPRISE_ROULETTE_KEY:int = 190001;
      
      public static const CARD_CARTON:int = 112168;
      
      public static const Silver_Caddy:int = 112100;
      
      public static const Gold_Caddy:int = 112101;
      
      public static const CADDY:int = 112047;
      
      public static const GOLD_CADDY:int = 112101;
      
      public static const SILVER_CADDY:int = 112100;
      
      public static const CADDY_KEY:int = 11456;
      
      public static const CADDY_BAGI:int = 112054;
      
      public static const CADDY_BAGII:int = 112055;
      
      public static const CADDY_BAGIII:int = 112056;
      
      public static const BEAD_ATTRIBUTE:int = 313500;
      
      public static const BEAD_ATTACK:int = 311500;
      
      public static const BEAD_DEFENSE:int = 312500;
      
      public static const MYSTICAL_CARDBOX:int = 112150;
      
      public static const MY_CARDBOX:int = 112108;
      
      public static const OFFER_PACK_I:int = 11252;
      
      public static const OFFER_PACK_II:int = 11257;
      
      public static const OFFER_PACK_III:int = 11258;
      
      public static const OFFER_PACK_IV:int = 11259;
      
      public static const OFFER_PACK_V:int = 11260;
      
      public static const Caddy_Good:int = 11907;
      
      public static const Save_Life:int = 11908;
      
      public static const Agility_Get:int = 11909;
      
      public static const ReHealth:int = 11910;
      
      public static const Train_Good:int = 11911;
      
      public static const Level_Try:int = 11912;
      
      public static const Card_Get:int = 11913;
      
      public static const FREE_PROP_CARD:int = 11995;
      
      public static const DOUBLE_EXP_CARD:int = 11998;
      
      public static const DOUBLE_GESTE_CARD:int = 11997;
      
      public static const PREVENT_KICK:int = 11996;
      
      public static const CHANGE_NAME_CARD:int = 11994;
      
      public static const CONSORTIA_CHANGE_NAME_CARD:int = 11993;
      
      public static const Pay_Buff:int = -1;
      
      public static const STRENGTH_GIFT_BAG:int = 112051100;
      
      public static const SYMBLE:int = 11020;
      
      public static const LUCKY:int = 11018;
      
      public static const STRENGTH_STONE4:int = 11023;
      
      public static const WEDDING_RING:int = 9022;
      
      public static const PIAN_OPENHOLE_STONE:int = 11034;
      
      public static const SKY_OPENHOLE_STONE:int = 11036;
      
      public static const GND_OPENHOLE_STONE:int = 11035;
      
      public static const BADLUCK_STONE:int = 11550;
      
      public static const TEXP_LV_II:int = 40002;
      
      public static const HEAD:uint = 1;
      
      public static const GLASS:uint = 2;
      
      public static const HAIR:uint = 3;
      
      public static const EFF:uint = 4;
      
      public static const CLOTH:uint = 5;
      
      public static const FACE:uint = 6;
      
      public static const ARM:uint = 7;
      
      public static const ARMLET:uint = 8;
      
      public static const RING:uint = 9;
      
      public static const FRIGHTPROP:uint = 10;
      
      public static const UNFRIGHTPROP:uint = 11;
      
      public static const TASK:uint = 12;
      
      public static const SUITS:uint = 13;
      
      public static const NECKLACE:uint = 14;
      
      public static const WING:uint = 15;
      
      public static const CHATBALL:uint = 16;
      
      public static const OFFHAND:int = 17;
      
      public static const CARDBOX:int = 18;
      
      public static const HEALSTONE:int = 19;
      
      public static const TEXP:int = 20;
      
      public static const TEXP_TASK:int = 23;
      
      public static const TITLE_CARD:int = 24;
      
      public static const ACTIVE_TASK:int = 30;
      
      public static const TEMPWEAPON:int = 27;
      
      public static const TEMPARMLET:uint = 28;
      
      public static const TEMPRING:uint = 29;
      
      public static const TEMP_OFFHAND:uint = 31;
      
      public static const GIFTGOODS:int = 25;
      
      public static const CARDEQUIP:int = 26;
      
      public static const CATHARINE:int = 21;
      
      public static const EFFECT:int = 30;
      
      public static const LABYINTH_DOBLE_AWARD:int = 11916;
      
      public static const LABYINTH_DOBLE_AWARD_GOODS_ID:int = 1191601;
      
      public static const GIVING:int = 100;
      
      public static const TYPES:Array = ["","head","glass","hair","eff","cloth","face","arm","armlet","ring","","","","suits","necklace","wing","chatBall","","","","","","","","","","","","armlet","ring"];
      
      public static const PARTNAME:Array = ["",LanguageMgr.GetTranslation("tank.data.EquipType.head"),LanguageMgr.GetTranslation("tank.data.EquipType.glass"),LanguageMgr.GetTranslation("tank.data.EquipType.hair"),LanguageMgr.GetTranslation("tank.data.EquipType.face"),LanguageMgr.GetTranslation("tank.data.EquipType.clothing"),LanguageMgr.GetTranslation("tank.data.EquipType.eye"),LanguageMgr.GetTranslation("tank.data.EquipType.weapon"),LanguageMgr.GetTranslation("tank.data.EquipType.bangle"),LanguageMgr.GetTranslation("tank.data.EquipType.finger"),LanguageMgr.GetTranslation("tank.data.EquipType.tool"),LanguageMgr.GetTranslation("tank.data.EquipType.normal"),"",LanguageMgr.GetTranslation("tank.data.EquipType.suit"),LanguageMgr.GetTranslation("tank.data.EquipType.necklace"),LanguageMgr.GetTranslation("tank.data.EquipType.decorate"),LanguageMgr.GetTranslation("tank.data.EquipType.paopao"),LanguageMgr.GetTranslation("tank.data.EquipType.offhand"),"",LanguageMgr.GetTranslation("tank.manager.ItemManager.aid"),LanguageMgr.GetTranslation("tank.data.EquipType.normal"),LanguageMgr.GetTranslation("tank.manager.ItemManager.cigaretteAsh"),"",LanguageMgr.GetTranslation("tank.data.EquipType.normal"),LanguageMgr.GetTranslation("tank.data.EquipType.normal"),LanguageMgr.GetTranslation("tank.manager.ItemManager.gift"),"",LanguageMgr.GetTranslation("tank.data.EquipType.tempweapon"),LanguageMgr.GetTranslation("tank.data.EquipType.TEMPARMLET"),LanguageMgr.GetTranslation("tank.data.EquipType.tempTEMPRING"),LanguageMgr.GetTranslation("tank.data.EquipType.prop"),LanguageMgr.GetTranslation("tank.data.EquipType.offhand"),LanguageMgr.GetTranslation("tank.data.EquipType.seed"),LanguageMgr.GetTranslation("tank.data.EquipType.manure"),LanguageMgr.GetTranslation("tank.data.EquipType.food"),LanguageMgr.GetTranslation("tank.data.EquipType.petEgg"),LanguageMgr.GetTranslation("tank.data.EquipType.vegetable"),LanguageMgr.GetTranslation("tank.data.EquipType.atacckt"),LanguageMgr.GetTranslation("tank.data.EquipType.defent"),LanguageMgr.GetTranslation("tank.data.EquipType.attribute"),LanguageMgr.GetTranslation("tank.data.EquipType.leagueBadge"),"","","","","","","","","",LanguageMgr.GetTranslation("tank.data.EquipType.petTool"),LanguageMgr.GetTranslation("tank.data.EquipType.petHead"),LanguageMgr.GetTranslation("tank.data.EquipType.petClothing"),"","","","","","","","",LanguageMgr.GetTranslation("tank.data.EquipType.magicStone"),LanguageMgr.GetTranslation("tank.data.EquipType.normal")];
      
      private static const dressAbleIDs:Array = [1,2,3,4,5,6,13,15];
      
      private static const DrillCategoryID:int = 11;
      
      private static const DrillCategotyProperty:String = "16";
      
      public static const HoleMaxExp:int = 100;
      
      public static const HoleMaxLevel:int = 4;
      
      private static const AttributeBeadLv1:int = 313199;
      
      private static const AttributeBeadLv2:int = 313299;
      
      private static const AttributeBeadLv3:int = 313399;
      
      private static const AttributeBeadLv4:int = 313499;
      
      private static const AttackBeadLv1:int = 311199;
      
      private static const AttackBeadLv2:int = 311299;
      
      private static const AttackBeadLv3:int = 311399;
      
      private static const AttackBeadLv4:int = 311499;
      
      private static const DefenceBeadLv1:int = 312199;
      
      private static const DefenceBeadLv2:int = 312299;
      
      private static const DefenceBeadLv3:int = 312399;
      
      private static const DefenceBeadLv4:int = 312499;
      
      public static const LaserBomdID:int = 87;
      
      public static const FLY_CD:int = 2;
      
      public static const FLY_ENERGY:int = 150;
      
      public static const ADD_TWO_ATTACK:int = 10001;
      
      public static const ADD_ONE_ATTACK:int = 10002;
      
      public static const THREEKILL:int = 10003;
      
      public static const FLY:int = 10006;
      
      public static const Angle:int = 17001;
      
      public static const TrueAngle:int = 17002;
      
      public static const ExllenceAngle:int = 17005;
      
      public static const FlyAngle:int = 17000;
      
      public static const TrueShield:int = 17003;
      
      public static const ExcellentShield:int = 17004;
      
      public static const CardMaxLv:int = 30;
      
      public static const GuildBomb:int = 10017;
      
      public static const Hiding:int = 10010;
      
      public static const HidingGroup:int = 10011;
      
      public static const HealthGroup:int = 10009;
      
      public static const Health:int = 10012;
      
      public static const Freeze:int = 10015;
      
      public static const FOOD:int = 34;
      
      public static const PET_EGG:int = 35;
      
      public static const BADGE:int = 40;
      
      public static const PET_EQUIP_CLOTH:int = 52;
      
      public static const PET_EQUIP_HEAD:int = 51;
      
      public static const PET_EQUIP_ARM:int = 50;
      
      public static const EXALT_ROCK:int = 11150;
      
      public static const SEED:int = 32;
      
      public static const MANURE:int = 33;
      
      public static const VEGETABLE:int = 36;
      
      public static const SPECIAL:int = 31;
      
      public static const SUPER_PET_EXP_FOOD:int = 334102;
	  
	  public static const LUCKYSTAR_ID:int = 201192;
	  
	  public static const GEMSTONE:int = 100100;
	  
	  public static const NECKLACE_PTETROCHEM_STONE:int = 11160;
       
      
      public function EquipType()
      {
         super();
      }
      
      public static function getPropNameByType(param1:int) : String
      {
         switch(param1)
         {
            case 1:
               return "composestone";
            case 2:
               return "StrengthStoneCell";
            case 3:
               return "symbol";
            case 4:
               return "sbugle";
            case 5:
               return "bbugle";
            case 6:
               return "packages";
            case 7:
               return "symbol";
            case 8:
               return "other";
            default:
               return "";
         }
      }
      
      public static function dressAble(param1:ItemTemplateInfo) : Boolean
      {
         if(dressAbleIDs.indexOf(param1.CategoryID) != -1)
         {
            return true;
         }
         return false;
      }
      
      public static function isRongLing(param1:ItemTemplateInfo) : Boolean
      {
         return param1.FusionType != 0 && param1.FusionRate > 0;
      }
      
      public static function isJewelryOrRing(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == 8 || param1.CategoryID == 9;
      }
      
      public static function isCards(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == CARDEQUIP;
      }
      
      public static function isWeddingRing(param1:ItemTemplateInfo) : Boolean
      {
         switch(param1.TemplateID)
         {
            case 9022:
            case 9122:
            case 9222:
            case 9322:
            case 9422:
            case 9522:
               return true;
            default:
               return false;
         }
      }
      
      public static function isPropertyWater(param1:ItemTemplateInfo) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         if(param1.CategoryID == 11 && (int(param1.Property1) >= 74 && int(param1.Property1) <= 80) || param1.TemplateID >= 1120098 && param1.TemplateID <= 1120101)
         {
            return true;
         }
         return false;
      }
      
      public static function isEditable(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.CategoryID <= 6 && param1.CategoryID >= 1)
         {
            if(param1.Property6 == "0")
            {
               return true;
            }
         }
         return false;
      }
      
      public static function canBeUsed(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.CategoryID == 11 && param1.Property1 == "5" && param1.Property2 != "0")
         {
            return true;
         }
         if(param1.CategoryID == 11 && param1.Property1 == "21")
         {
            return true;
         }
         if(param1.CategoryID == 11 && param1.Property1 == "100")
         {
            return true;
         }
         if(param1.CategoryID == 11 && param1.Property1 == "37")
         {
            return true;
         }
         if(param1.CategoryID == 11 && (param1.Property1 == "27" || param1.Property1 == "29"))
         {
            return true;
         }
         if(param1.CategoryID == EquipType.CARDBOX)
         {
            return true;
         }
         if(param1.CategoryID == EquipType.TEXP_TASK)
         {
            return true;
         }
         if(param1.CategoryID == EquipType.PET_EGG)
         {
            return true;
         }
         if(param1.CategoryID == EquipType.CHANGE_SEX)
         {
            return true;
         }
         if(param1.CategoryID == EquipType.TITLE_CARD)
         {
            return true;
         }
         if(isPropertyWater(param1))
         {
            return true;
         }
         switch(param1.TemplateID)
         {
            case EquipType.TRANSFER_PROP:
            case EquipType.COLORCARD:
            case EquipType.FREE_PROP_CARD:
            case EquipType.DOUBLE_EXP_CARD:
            case EquipType.DOUBLE_GESTE_CARD:
            case EquipType.PREVENT_KICK:
            case EquipType.Caddy_Good:
            case EquipType.Save_Life:
            case EquipType.Agility_Get:
            case EquipType.ReHealth:
            case EquipType.Train_Good:
            case EquipType.Level_Try:
            case EquipType.Card_Get:
            case EquipType.CHANGE_NAME_CARD:
            case EquipType.CONSORTIA_CHANGE_NAME_CARD:
            case EquipType.VIPCARD:
            case EquipType.VIPCARD_TEST:
            case EquipType.WISHBEAD_ATTACK:
            case EquipType.WISHBEAD_DEFENSE:
            case EquipType.WISHBEAD_AGILE:
            case EquipType.CHANGE_SEX:
			case EquipType.GEMSTONE:
               return true;
            default:
               return false;
         }
      }
      
      public static function isEquipBoolean(param1:ItemTemplateInfo) : Boolean
      {
         switch(param1.CategoryID)
         {
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
            case 8:
            case 9:
            case 13:
            case 14:
            case 15:
            case 16:
            case 17:
            case 18:
            case HEALSTONE:
            case BADGE:
               return true;
            default:
               return false;
         }
      }
      
      public static function isBelongToPropBag(param1:ItemTemplateInfo) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         switch(param1.CategoryID)
         {
            case EquipType.FRIGHTPROP:
            case EquipType.UNFRIGHTPROP:
            case EquipType.TASK:
            case EquipType.TEXP:
            case EquipType.TEXP_TASK:
            case EquipType.ACTIVE_TASK:
            case EquipType.FOOD:
            case EquipType.PET_EGG:
               return true;
            default:
               return false;
         }
      }
      
      public static function isPetEgg(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == EquipType.PET_EGG;
      }
      
      public static function isHealStone(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == HEALSTONE;
      }
      
      public static function isFusion(param1:ItemTemplateInfo) : Boolean
      {
         return param1.FusionType != 0 && param1.FusionRate > 0;
      }
      
      public static function isStrengthStone(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.CategoryID != UNFRIGHTPROP)
         {
            return false;
         }
         if(param1.Property1 == "2" || param1.Property1 == "35")
         {
            return true;
         }
         return false;
      }
      
      public static function isSymbol(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.CategoryID != UNFRIGHTPROP)
         {
            return false;
         }
         if(param1.Property1 == "3")
         {
            return true;
         }
         return false;
      }
      
      public static function isBugle(param1:ItemTemplateInfo) : Boolean
      {
         return param1.TemplateID == 11101 || param1.TemplateID == 11102;
      }
      
      public static function isEquip(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.CategoryID >= 1 && param1.CategoryID < 10 && param1.CategoryID != 7)
         {
            return true;
         }
         return false;
      }
      
      public static function isHead(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == HEAD;
      }
      
      public static function isCloth(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == CLOTH;
      }
      
      public static function isAvatar(param1:int) : Boolean
      {
         return [HEAD,GLASS,HAIR,EFF,CLOTH,FACE,SUITS,WING].indexOf(param1) != -1;
      }
      
      public static function isArm(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == 7 || param1.CategoryID == 27;
      }
      
      public static function canEquip(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.CategoryID >= 1 && param1.CategoryID < 20 && param1.CategoryID != 18 && param1.CategoryID != 11 && param1.CategoryID != 12 && param1.CategoryID != 10 || param1.CategoryID == 27 || param1.CategoryID == 50 || param1.CategoryID == 51 || param1.CategoryID == 52 || param1.CategoryID == EquipType.TEMPARMLET || param1.CategoryID == EquipType.TEMPRING || param1.CategoryID == EquipType.TEMP_OFFHAND || param1.CategoryID == EquipType.BADGE)
         {
            return true;
         }
         return false;
      }
      
      public static function isChest(param1:ItemTemplateInfo) : Boolean
      {
         return param1.Property1 == "6";
      }
      
      public static function isMissionGoods(param1:ItemTemplateInfo) : Boolean
      {
         return param1.Property1 == "10";
      }
      
      public static function isProp(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == FRIGHTPROP || param1.CategoryID == UNFRIGHTPROP;
      }
      
      public static function isTask(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == TASK;
      }
      
      public static function isPackage(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == UNFRIGHTPROP && param1.Property1 == "6";
      }
      
      public static function isCardBox(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == CARDBOX;
      }
      
      public static function isCard(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == UNFRIGHTPROP && (param1.Property1 == "12" || param1.Property1 == "13");
      }
      
      public static function isCanBatchHandler(param1:InventoryItemInfo) : Boolean
      {
         return param1 && param1.Property4 == "2" && param1.Count > 1;
      }
      
      public static function placeToCategeryId(param1:int) : int
      {
         switch(param1)
         {
            case 7:
            case 8:
               return 8;
            case 9:
            case 10:
               return 9;
            default:
               return param1 + 1;
         }
      }
      
      public static function CategeryIdToPlace(param1:int) : Array
      {
         switch(param1)
         {
            case 8:
            case EquipType.TEMPARMLET:
               return [7,8];
            case 9:
            case EquipType.TEMPRING:
               return [9,10];
            case 13:
               return [11];
            case 14:
               return [12];
            case 15:
               return [13];
            case 16:
               return [14];
            case OFFHAND:
            case TEMP_OFFHAND:
               return [15];
            case TEMPWEAPON:
               return [6];
            case BADGE:
               return [17];
            default:
               return [param1 - 1];
         }
      }
      
      public static function hasSkin(param1:int) : Boolean
      {
         return param1 == FACE || param1 == CLOTH;
      }
      
      public static function getRongLingEquipLevel(param1:ItemTemplateInfo) : int
      {
         if(isRongLing(param1))
         {
            return int(param1.Property1);
         }
         return 0;
      }
      
      public static function isCaddy(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.TemplateID == CADDY || param1.TemplateID == Silver_Caddy || param1.TemplateID == Gold_Caddy)
         {
            return true;
         }
         return false;
      }
      
      public static function isValuableEquip(param1:ItemTemplateInfo) : Boolean
      {
         var _loc2_:InventoryItemInfo = param1 as InventoryItemInfo;
         if(_loc2_)
         {
            if(_loc2_.CategoryID == 27 || _loc2_.CategoryID == EquipType.TEMPARMLET || _loc2_.CategoryID == EquipType.TEMPRING)
            {
               return true;
            }
            if(_loc2_.CategoryID == HEAD || _loc2_.CategoryID == CLOTH || _loc2_.CategoryID == ARM || _loc2_.CategoryID == OFFHAND)
            {
               if(_loc2_.StrengthenLevel >= 7)
               {
                  return true;
               }
            }
            if(_loc2_.CategoryID == ARMLET || _loc2_.CategoryID == RING)
            {
               if(int(_loc2_.Property1) >= 3)
               {
                  return true;
               }
            }
            return false;
         }
         return false;
      }
      
      public static function isDrill(param1:InventoryItemInfo) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         return param1.CategoryID == DrillCategoryID && param1.Property1 == DrillCategotyProperty;
      }
      
      public static function isBead(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == 11 && param1.Property1 == "31";
      }
      
      public static function isAttackBead(param1:ItemTemplateInfo) : Boolean
      {
         return isBead(param1) && param1.Property2 == "1";
      }
      
      public static function isDefenceBead(param1:ItemTemplateInfo) : Boolean
      {
         return isBead(param1) && param1.Property2 == "2";
      }
      
      public static function isAttributeBead(param1:ItemTemplateInfo) : Boolean
      {
         return isBead(param1) && param1.Property2 == "3";
      }
      
      public static function isBeadFromSmelt(param1:ItemTemplateInfo) : Boolean
      {
         return isBeadFromSmeltByID(param1.TemplateID);
      }
      
      public static function isBeadFromSmeltByID(param1:int) : Boolean
      {
         return BeadModel.getInstance().isBeadFromSmelt(param1);
      }
      
      public static function isAttackBeadFromSmeltByID(param1:int) : Boolean
      {
         return BeadModel.getInstance().isAttackBead(ItemManager.Instance.getTemplateById(param1));
      }
      
      public static function isDefenceBeadFromSmeltByID(param1:int) : Boolean
      {
         return BeadModel.getInstance().isDefenceBead(ItemManager.Instance.getTemplateById(param1));
      }
      
      public static function isAttributeBeadFromSmeltByID(param1:int) : Boolean
      {
         return BeadModel.getInstance().isAttributeBead(ItemManager.Instance.getTemplateById(param1));
      }
      
      public static function isOfferPackage(param1:ItemTemplateInfo) : Boolean
      {
         switch(param1.TemplateID)
         {
            case OFFER_PACK_I:
            case OFFER_PACK_II:
            case OFFER_PACK_III:
            case OFFER_PACK_IV:
            case OFFER_PACK_V:
               return true;
            default:
               return false;
         }
      }
      
      public static function isBeadNeedOpen(param1:ItemTemplateInfo) : Boolean
      {
         if(isBeadFromSmelt(param1))
         {
            return true;
         }
         switch(param1.TemplateID)
         {
            case BEAD_ATTACK:
            case BEAD_ATTRIBUTE:
            case BEAD_DEFENSE:
            case MYSTICAL_CARDBOX:
               return true;
            default:
               return false;
         }
      }
      
      public static function isComposeStone(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == 11 && param1.Property1 == "1";
      }
      
      public static function isFusionFormula(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == 11 && param1.Property1 == "8";
      }
      
      public static function isCaddyCanBay(param1:ItemTemplateInfo) : Boolean
      {
         return param1.TemplateID == CADDY;
      }
      
      public static function isTimeBox(param1:ItemTemplateInfo) : Boolean
      {
         return param1.CategoryID == 11 && param1.Property1 == "6" && param1.Property2 == "4";
      }
      
      public static function isAngel(param1:ItemTemplateInfo) : Boolean
      {
         return param1.TemplateID == Angle || param1.TemplateID == TrueAngle || param1.TemplateID == ExllenceAngle || param1.TemplateID == FlyAngle;
      }
      
      public static function isShield(param1:ItemTemplateInfo) : Boolean
      {
         return param1.TemplateID == TrueShield || param1.TemplateID == ExcellentShield;
      }
      
      public static function hasPropAnimation(param1:ItemTemplateInfo) : String
      {
         switch(param1.TemplateID)
         {
            case Hiding:
            case HidingGroup:
               return "hiding";
            case Health:
            case HealthGroup:
               return "health";
            case Freeze:
               return "freeze";
            default:
               return null;
         }
      }
      
      public static function isPetSpeciallFood(param1:ItemTemplateInfo) : Boolean
      {
         return param1.TemplateID == 334100;
      }
      
      public static function isExaltStone(param1:ItemTemplateInfo) : Boolean
      {
         if(param1.CategoryID != UNFRIGHTPROP)
         {
            return false;
         }
         if(param1.Property1 == "2" || param1.Property1 == "45")
         {
            return true;
         }
         return false;
      }
   }
}
