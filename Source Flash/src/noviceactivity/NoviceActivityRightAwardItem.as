package noviceactivity
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import bagAndInfo.cell.BagCell;
   
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.GameInSocketOut;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   
   public class NoviceActivityRightAwardItem extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _conditionTxt:FilterFrameText;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _alreadyGet:Bitmap;
      
      private var _getShine:MovieClip;
      
      private var _condition:int;
      
      private var _selfCondition:int;
      
      private var _index:int;
      
      private var _record:int;
      
      private var _awards:Array;
      
      private var _subType:int;
      
      private var _type:int;
      
      public function NoviceActivityRightAwardItem()
      {
         super();
      }
	  
	  public function get getIndex() : int{
		  return this._index;
	  }
      
      private function initView() : void
      {
         var _loc1_:Point = null;
         var _loc4_:BagCell = null;
         _loc1_ = null;
         _loc4_ = null;
         _loc1_ = null;
         var _loc3_:InventoryItemInfo = null;
         _loc4_ = null;
		 try{
			 this._bg = ComponentFactory.Instance.creatBitmap("asset.novice.rightview.awarditem.bg");
			 addChild(this._bg);
			 this._conditionTxt = ComponentFactory.Instance.creatComponentByStylename("noviceactiviy.rightawarditem.conditionTxt");
			 addChild(this._conditionTxt);
			 this._conditionTxt.text = LanguageMgr.GetTranslation("noviceactivity.rightView.conditionTxt" + this._type,this._condition);
			 if(this._type == 2)
			 {
				 this._conditionTxt.y = 5;
			 }
			 this._getShine = ClassUtils.CreatInstance("asset.novice.rightview.awarditem.getbtn.shine");
			 PositionUtils.setPos(this._getShine,"noviceactivity.rightItem.getshine.pos");
			 addChild(this._getShine);
			 this._getShine.visible = false;
			 this._getBtn = ComponentFactory.Instance.creatComponentByStylename("noviceactiviy.rightawarditem.getBtn");
			 addChild(this._getBtn);
			 this._alreadyGet = ComponentFactory.Instance.creatBitmap("asset.novice.rightview.awarditem.alreadygetbtn");
			 addChild(this._alreadyGet);
			 this._alreadyGet.visible = false;
			 this._getBtn.visible = false;
			 this._getBtn.addEventListener(MouseEvent.CLICK,this.__getAward);
			 _loc1_ = PositionUtils.creatPoint("noviceactivity.rightItem.awardcells.pos");
			 var _loc2_:int = 0;
			 while(_loc2_ < this._awards.length)
			 {
				 _loc3_ = new InventoryItemInfo();
				 _loc3_.TemplateID = this._awards[_loc2_].TemplateID;
				 _loc3_.Count = this._awards[_loc2_].Count;
				 _loc3_.StrengthenLevel = this._awards[_loc2_].StrengthLevel;
				 _loc3_.AttackCompose = this._awards[_loc2_].AttackCompose;
				 _loc3_.DefendCompose = this._awards[_loc2_].DefendCompose;
				 _loc3_.LuckCompose = this._awards[_loc2_].LuckCompose;
				 _loc3_.AgilityCompose = this._awards[_loc2_].AgilityCompose;
				 _loc3_.IsBinds = this._awards[_loc2_].IsBind;
				 _loc3_.ValidDate = this._awards[_loc2_].ValidDate;
				 ItemManager.fill(_loc3_);
				 _loc4_ = new BagCell(0,_loc3_,false,ComponentFactory.Instance.creatBitmap("asset.novice.rightview.awarditem.cell.bg"),false);
				 _loc4_.setContentSize(41,41);
				 _loc4_.setCount(_loc3_.Count);
				 _loc4_.x = _loc1_.x + 45 * _loc2_;
				 _loc4_.y = _loc1_.y;
				 addChild(_loc4_);
				 _loc2_++;
			 }
			 this.refreshBtn(); 
		 } catch(e:*){
			 SocketManager.Instance.out.sendErrorMsg("err:" + e);
		 }
      }
      
      public function refreshBtn() : void
      {
         if(this._selfCondition >= this._condition)
         {
            if(NoviceActivityManager.instance.canGetAward(this._record,this._index))
            {
               this._getShine.visible = true;
               this._getShine.gotoAndPlay(1);
               this._getBtn.visible = true;
               this._getBtn.enable = true;
               this._alreadyGet.visible = false;
            }
            else
            {
               this._getBtn.visible = false;
               this._alreadyGet.visible = true;
            }
         }
         else
         {
            this._getShine.visible = false;
            this._getBtn.visible = true;
            this._getBtn.enable = false;
            this._alreadyGet.visible = false;
         }
      }
      
      public function setInfo(param1:int, param2:int, param3:NoviceActivityInfo, param4:NoviceActivityRightAwardInfo) : void
      {
         this._index = param1;
         this._type = param2;
         this._selfCondition = param3.conditions;
         this._record = param3.awardGot;
         this._condition = param4.condition;
         this._subType = param4.subActivityType;
         this._awards = param4.awardList;
         this.initView();
      }
      
      private function __getAward(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         GameInSocketOut.sendNoviceActivityGetAward(this._type,this._subType);
      }
      
      private function removeEvent() : void
      {
         if(this._getBtn)
         {
            this._getBtn.removeEventListener(MouseEvent.CLICK,this.__getAward);
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._conditionTxt)
         {
            ObjectUtils.disposeObject(this._conditionTxt);
         }
         this._conditionTxt = null;
         if(this._getBtn)
         {
            ObjectUtils.disposeObject(this._getBtn);
         }
         this._getBtn = null;
         if(this._alreadyGet)
         {
            ObjectUtils.disposeObject(this._alreadyGet);
         }
         this._alreadyGet = null;
         if(this._getShine)
         {
            ObjectUtils.disposeObject(this._getShine);
         }
         this._getShine = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
