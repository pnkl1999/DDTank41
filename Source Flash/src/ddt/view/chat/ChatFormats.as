package ddt.view.chat
{
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.data.goods.QualityType;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.utils.Helpers;
   import flash.text.StyleSheet;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import road7th.utils.StringHelper;
   
   public class ChatFormats
   {
      
      public static const CHAT_COLORS:Array = [2358015,16751360,16740090,4970320,8423901,16777215,16776960,16776960,16776960,16777215,5035345,16724787,16777011,16777215,16711846,16515684];
      
      public static const BIG_BUGGLE_COLOR:Array = [11408476,16635586,15987916,16514727,12053748];
      
      public static const BIG_BUGGLE_TYPE_STRING:Array = ["Mối tình đầu","Chúc mừng sinh nhật","Lá lành đùm lá rách","Vua thách đấu","Đời không đối thủ"];
      
      public static const CLICK_CHANNEL:int = 0;
      
      public static const CLICK_GOODS:int = 2;
      
      public static const CLICK_USERNAME:int = 1;
      
      public static const CLICK_DIFF_ZONE:int = 4;
      
      public static const CLICK_INVENTORY_GOODS:int = 3;
      
      public static const CLICK_EFFORT:int = 100;
      
      public static const Channel_Set:Object = {
         0:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.big"),
         1:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.small"),
         2:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.private"),
         3:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.consortia"),
         4:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.ream"),
         5:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         9:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         12:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.cross"),
         13:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.current"),
         15:LanguageMgr.GetTranslation("tank.view.chat.ChannelListSelectView.crossBugle")
      };
      
      public static var hasYaHei:Boolean;
      
      private static var _formats:Dictionary;
      
      private static var _styleSheet:StyleSheet;
      
      private static var _gameStyleSheet:StyleSheet;
      
      private static var _styleSheetData:Dictionary;
      
      private static var _chatData:ChatData;
      
      private static const unacceptableChar:Array = ["\"","\'","<",">"];
      
      private static const IN_GAME:uint = 1;
      
      private static const NORMAL:uint = 0;
	  
	  public static const CLICK_LANTERN_BEGIN:int = 104;
	  
	  public static const CLICK_TIME_GIFTPACK:int = 105;
       
      
      public function ChatFormats()
      {
         super();
      }
      
      public static function formatChatStyle(param1:ChatData) : void
      {
         if(param1.htmlMessage != "")
         {
            return;
         }
         param1.msg = StringHelper.rePlaceHtmlTextField(param1.msg);
         var _loc2_:Array = getTagsByChannel(param1.channel);
         var _loc3_:String = creatChannelTag(param1.channel,param1.bigBuggleType,param1);
         var _loc4_:String = creatSenderTag(param1);
         var _loc5_:String = creatContentTag(param1);
         param1.htmlMessage = _loc2_[0] + _loc3_ + _loc4_ + _loc5_ + _loc2_[1] + "<BR>";
      }
      
      public static function creatBracketsTag(param1:String, param2:int, param3:Array = null, param4:ChatData = null) : String
      {
         var _loc9_:String = null;
         var _loc5_:RegExp = /\[([^\]]*)]*/g;
         var _loc6_:Array = param1.match(_loc5_);
         var _loc7_:String = "";
         if(param3)
         {
            _loc7_ = param3.join("|");
         }
         var _loc8_:int = 0;
		 var _valueLantern_:int = 0; 
		 if(param2 == CLICK_LANTERN_BEGIN)
		 {
			 _valueLantern_ = param1.indexOf(".") + 1;
			 param1 = param1.slice(0,_valueLantern_) + "<u>" + "<a href=\"event:" + "clicktype:" + param2.toString() + "\">" + param1.slice(_valueLantern_,param1.length) + "</a></u>";
		 }
         while(_loc8_ < _loc6_.length)
         {
            _loc9_ = _loc6_[_loc8_].substr(1,_loc6_[_loc8_].length - 2);
            if(param2 != CLICK_USERNAME || _loc9_ != PlayerManager.Instance.Self.NickName)
            {
               if(param4 && param4.channel == ChatInputView.CROSS_NOTICE)
               {
                  param1 = param1.replace("[" + _loc9_ + "]","<a href=\"event:" + "clicktype:" + param2.toString() + "|tagname:" + _loc9_ + "|zoneID:" + String(param4.zoneID) + _loc7_ + "\">" + Helpers.enCodeString("[" + _loc9_ + "]") + "</a>");
               }
               else if(_loc9_ == Channel_Set[12])
               {
                  param1 = "";
               }
               else
               {
                  param1 = param1.replace("[" + _loc9_ + "]","<a href=\"event:" + "clicktype:" + param2.toString() + "|tagname:" + _loc9_ + "|" + _loc7_ + "\">" + Helpers.enCodeString("[" + _loc9_ + "]") + "</a>");
               }
            }
            else
            {
               param1 = param1.replace("[" + _loc9_ + "]",Helpers.enCodeString("[" + _loc9_ + "]"));
            }
            _loc8_++;
         }
         return param1;
      }
      
      public static function creatGoodTag(param1:String, param2:int, param3:int, param4:int, param5:Boolean, param6:ChatData = null, param7:String = "", param8:int = -1) : String
      {
         var _loc14_:String = null;
         var _loc9_:Array = getTagsByQuality(param4);
         var _loc10_:RegExp = /\[([^\]]*)]*/g;
         var _loc11_:Array = param1.match(_loc10_);
         var _loc12_:int = param6.zoneID;
         var _loc13_:int = 0;
         while(_loc13_ < _loc11_.length)
         {
            _loc14_ = _loc11_[_loc13_].substr(1,_loc11_[_loc13_].length - 2);
            param1 = param1.replace("[" + _loc14_ + "]",_loc9_[0] + "<a href=\"event:" + "clicktype:" + param2.toString() + "|type:" + param8 + "|tagname:" + _loc14_ + "|isBind:" + param5.toString() + "|templeteIDorItemID:" + param3.toString() + "|key:" + param7 + "|zoneID:" + _loc12_ + "\">" + Helpers.enCodeString("[" + _loc14_ + "]") + "</a>" + _loc9_[1]);
            _loc13_++;
         }
         return param1;
      }
      
      public static function getColorByChannel(param1:int) : int
      {
         return CHAT_COLORS[param1];
      }
      
      public static function getColorByBigBuggleType(param1:int) : int
      {
         return BIG_BUGGLE_COLOR[param1];
      }
      
      public static function getTagsByChannel(param1:int) : Array
      {
         return ["<CT" + param1.toString() + ">","</CT" + param1.toString() + ">"];
      }
      
      public static function getTagsByQuality(param1:int) : Array
      {
         return ["<QT" + param1.toString() + ">","</QT" + param1.toString() + ">"];
      }
      
      public static function getTextFormatByChannel(param1:int) : TextFormat
      {
         return _formats[param1];
      }
      
      public static function setup() : void
      {
         setupFormat();
         setupStyle();
      }
      
      public static function get styleSheet() : StyleSheet
      {
         return _styleSheet;
      }
      
      public static function get gameStyleSheet() : StyleSheet
      {
         return _gameStyleSheet;
      }
      
      private static function getBigBuggleTypeString(param1:int) : String
      {
         return BIG_BUGGLE_TYPE_STRING[param1 - 1];
      }
      
      private static function creatChannelTag(param1:int, param2:int = 0, param3:ChatData = null) : String
      {
         var _loc4_:String = "";
         if(Channel_Set[param1] && param1 != ChatInputView.PRIVATE)
         {
            if(param2 == 0)
            {
               if(param1 != 15)
               {
                  _loc4_ = creatBracketsTag("[" + Channel_Set[param1] + "]",CLICK_CHANNEL,["channel:" + param1.toString()]);
               }
               else
               {
                  _loc4_ = creatBracketsTag("[" + Channel_Set[param1] + "]" + "&lt;" + param3.zoneName + "&gt;",CLICK_CHANNEL,["channel:" + param1.toString()]);
               }
            }
            else
            {
               _loc4_ = "[" + getBigBuggleTypeString(param2) + Channel_Set[param1] + "]";
            }
         }
         return _loc4_;
      }
      
      private static function creatContentTag(param1:ChatData) : String
      {
         var _loc4_:Object = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:ItemTemplateInfo = null;
         var _loc8_:String = null;
         var _loc9_:uint = 0;
         var _loc10_:String = null;
         var _loc2_:String = param1.msg;
         var _loc3_:uint = 0;
         if(param1.link)
         {
            param1.link.sortOn("index");
            for each(_loc4_ in param1.link)
            {
               _loc5_ = _loc4_.ItemID;
               _loc6_ = _loc4_.TemplateID;
               _loc7_ = ItemManager.Instance.getTemplateById(_loc6_);
               _loc8_ = _loc4_.key;
               _loc9_ = _loc4_.index + _loc3_;
               if(_loc5_ <= 0)
               {
                  _loc10_ = creatGoodTag("[" + _loc7_.Name + "]",CLICK_GOODS,_loc7_.TemplateID,_loc7_.Quality,true,param1);
               }
               else if(param1.type == 20 || param1.type == 18)
               {
                  _loc10_ = creatGoodTag("[" + _loc7_.Name + "]",CLICK_INVENTORY_GOODS,_loc5_,_loc7_.Quality,true,param1,_loc8_,param1.type);
               }
               else
               {
                  _loc10_ = creatGoodTag("[" + _loc7_.Name + "]",CLICK_INVENTORY_GOODS,_loc5_,_loc7_.Quality,true,param1,_loc8_);
               }
               _loc2_ = _loc2_.substring(0,_loc9_) + _loc10_ + _loc2_.substring(_loc9_);
               _loc3_ += _loc10_.length;
            }
         }
         if(param1.type == CLICK_EFFORT)
         {
            return creatBracketsTag(_loc2_,CLICK_EFFORT,null,param1);
         }
		 if(param1.type == CLICK_LANTERN_BEGIN || param1.type == CLICK_TIME_GIFTPACK)
		 {
			 return creatBracketsTag(_loc2_,param1.type,null,param1);
		 }
         if(param1.channel <= 5)
         {
            if(param1.type == CLICK_USERNAME || param1.type == CLICK_DIFF_ZONE)
            {
               return creatBracketsTag(_loc2_,CLICK_USERNAME,null,param1);
            }
            return _loc2_;
         }
         return creatBracketsTag(_loc2_,CLICK_USERNAME,null,param1);
      }
      
      private static function creatSenderTag(param1:ChatData) : String
      {
         var _loc2_:String = "";
         if(param1.sender == "")
         {
            return _loc2_;
         }
         if(param1.channel == ChatInputView.PRIVATE)
         {
            if(param1.sender == PlayerManager.Instance.Self.NickName)
            {
               _loc2_ = creatBracketsTag(LanguageMgr.GetTranslation("tank.view.chatsystem.sendTo") + "[" + param1.receiver + "]: ",CLICK_USERNAME,null,param1);
            }
            else
            {
               _loc2_ = creatBracketsTag("[" + param1.sender + "]" + LanguageMgr.GetTranslation("tank.view.chatsystem.privateSayToYou"),CLICK_USERNAME,null,param1);
            }
         }
         else if(param1.zoneID == PlayerManager.Instance.Self.ZoneID || param1.zoneID <= 0)
         {
            _loc2_ = creatBracketsTag("[" + param1.sender + "]: ",CLICK_USERNAME,null,param1);
         }
         else
         {
            _loc2_ = creatBracketsTag("[" + param1.sender + "]: ",CLICK_DIFF_ZONE,null,param1);
         }
         return _loc2_;
      }
      
      public static function replaceUnacceptableChar(param1:String) : String
      {
         var _loc2_:int = 0;
         while(_loc2_ < unacceptableChar.length)
         {
            param1 = param1.replace(unacceptableChar[_loc2_],"");
            _loc2_++;
         }
         return param1;
      }
      
      private static function creatStyleObject(param1:int, param2:uint = 0) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:String = null;
         switch(param2)
         {
            case NORMAL:
               _loc4_ = "13";
               break;
            case IN_GAME:
               _loc4_ = "12";
         }
         return {
            "color":"#" + param1.toString(16),
            "leading":"5",
            "fontFamily":"Arial",
            "display":"inline",
            "fontSize":_loc4_
         };
      }
      
      private static function setupFormat() : void
      {
         var _loc2_:TextFormat = null;
         _formats = new Dictionary();
         var _loc1_:int = 0;
         while(_loc1_ < CHAT_COLORS.length)
         {
            _loc2_ = new TextFormat();
            _loc2_.font = "Arial";
            _loc2_.size = 13;
            _loc2_.color = CHAT_COLORS[_loc1_];
            _formats[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      private static function setupStyle() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         _styleSheetData = new Dictionary();
         _styleSheet = new StyleSheet();
         _gameStyleSheet = new StyleSheet();
         var _loc1_:int = 0;
         while(_loc1_ < QualityType.QUALITY_COLOR.length)
         {
            _loc3_ = creatStyleObject(QualityType.QUALITY_COLOR[_loc1_]);
            _loc4_ = creatStyleObject(QualityType.QUALITY_COLOR[_loc1_],1);
            _styleSheetData["QT" + _loc1_] = _loc3_;
            _styleSheet.setStyle("QT" + _loc1_,_loc3_);
            _gameStyleSheet.setStyle("QT" + _loc1_,_loc4_);
            _loc1_++;
         }
         var _loc2_:int = 0;
         while(_loc2_ <= CHAT_COLORS.length)
         {
            _loc5_ = creatStyleObject(CHAT_COLORS[_loc2_]);
            _loc6_ = creatStyleObject(CHAT_COLORS[_loc2_],1);
            _styleSheetData["CT" + String(_loc2_)] = _loc5_;
            _styleSheet.setStyle("CT" + String(_loc2_),_loc5_);
            _gameStyleSheet.setStyle("CT" + String(_loc2_),_loc6_);
            _loc2_++;
         }
      }
   }
}
