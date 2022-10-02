package lightRoad.Item
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import lightRoad.info.LightGiftInfo;
   import lightRoad.manager.LightRoadManager;
   
   public class GiftItem extends Sprite implements Disposeable
   {
       
      
      private var _index:int = 0;
      
      private var _baseCell:BaseCell;
      
      private var _MaskMC:MovieClip;
      
      private var _numberText:FilterFrameText;
      
      private var _GiftMessage:LightGiftInfo;
      
      private var _activationBtn:BaseButton;
      
      private var _drawBtn:BaseButton;
      
      private var _branchMC:MovieClip;
      
      public function GiftItem(param1:int)
      {
         super();
         this._index = param1;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
      }
      
      private function initEvent() : void
      {
      }
      
      private function removeEvent() : void
      {
      }
      
      public function initItemCell(param1:LightGiftInfo) : void
      {
         var _loc2_:Point = null;
         _loc2_ = null;
         this.disposeCell();
         this._GiftMessage = param1;
         if(this._GiftMessage.Type == 0)
         {
            this._baseCell = this.creatItemCell();
         }
         else
         {
            this._baseCell = this.creatItemCell(60);
            _loc2_ = PositionUtils.creatPoint("light.giftItem.Pos2");
            this._baseCell.x = _loc2_.x;
            this._baseCell.y = _loc2_.y;
         }
         this._baseCell.info = this.GetTemplateInfo(this._GiftMessage.TemplateID);
         this._baseCell.info.ThingsFrom = this._GiftMessage.GetFrom;
         addChild(this._baseCell);
         this.upData();
      }
      
      public function upData() : void
      {
         this.removeNumberMC();
         this.removeMaskMC();
         this.removeActivationBtn();
         this.removeDrawBtn();
         this.removeBranchMC();
         if(this._GiftMessage.Type == 1)
         {
            this._MaskMC = ComponentFactory.Instance.creat("asset.lightroad.swf.circularMask");
            addChild(this._MaskMC);
            this._baseCell.mask = this._MaskMC;
            this._numberText = ComponentFactory.Instance.creatComponentByStylename("lightRoad.gift.Number2Txt");
            this._numberText.text = String(this._GiftMessage.Count);
            if(this._GiftMessage.Count == 1)
            {
               this._numberText.visible = false;
            }
            if(this._GiftMessage.GetType == 0)
            {
               this.checkPointNoDrawType();
            }
            else
            {
               this._baseCell.filters = [];
               this._numberText.visible = false;
            }
         }
         else
         {
            this._numberText = ComponentFactory.Instance.creatComponentByStylename("lightRoad.gift.Number1Txt");
            if(this._GiftMessage.GetType == 0)
            {
               this.checkBranchNoDrawType();
            }
            else
            {
               this._baseCell.filters = [];
               this._numberText.visible = false;
            }
         }
         addChild(this._numberText);
      }
      
      private function checkPointNoDrawType() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Boolean = true;
         var _loc6_:int = 0;
         _loc2_ = LightRoadManager.instance.model.pointGroup.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this._GiftMessage.Space == LightRoadManager.instance.model.pointGroup[_loc1_][0])
            {
               _loc4_ = LightRoadManager.instance.model.pointGroup[_loc1_][1].length;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  _loc6_ = LightRoadManager.instance.model.pointGroup[_loc1_][1][_loc3_] - 1;
                  if(LightRoadManager.instance.model.thingsType[_loc6_] == 0)
                  {
                     _loc5_ = false;
                     break;
                  }
                  _loc3_++;
               }
               break;
            }
            _loc1_++;
         }
         if(_loc5_)
         {
            this._baseCell.filters = [];
            this._branchMC = ComponentFactory.Instance.creat("asset.lightroad.swf.Branch.mc");
            this._branchMC.x = 25;
            this._branchMC.y = 25;
            addChild(this._branchMC);
            this._drawBtn = ComponentFactory.Instance.creat("lightRoad.Gift.draw.btn");
            addChild(this._drawBtn);
            this._drawBtn.addEventListener(MouseEvent.CLICK,this.__draw);
         }
         else
         {
            this._baseCell.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
         }
      }
      
      private function checkBranchNoDrawType() : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         var _loc4_:int = this._GiftMessage.TemplateID;
         _loc3_ = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(_loc4_);
         if(_loc3_ == 0)
         {
            _loc3_ = PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(_loc4_);
         }
         if(_loc3_ == 0)
         {
            _loc3_ = PlayerManager.Instance.Self.FightBag.getItemCountByTemplateId(_loc4_);
         }
         if(_loc3_ == 0)
         {
            _loc3_ = PlayerManager.Instance.Self.TempBag.getItemCountByTemplateId(_loc4_);
         }
         if(_loc3_ == 0)
         {
            _loc3_ = PlayerManager.Instance.Self.CaddyBag.getItemCountByTemplateId(_loc4_);
         }
         if(_loc3_ == 0)
         {
            _loc3_ = PlayerManager.Instance.Self.farmBag.getItemCountByTemplateId(_loc4_);
         }
         if(_loc3_ == 0)
         {
            _loc3_ = PlayerManager.Instance.Self.vegetableBag.getItemCountByTemplateId(_loc4_);
         }
         if(_loc3_ >= this._GiftMessage.Count)
         {
            this._baseCell.filters = [];
            this._branchMC = ComponentFactory.Instance.creat("asset.lightroad.swf.Branch.mc");
            this._branchMC.x = 25;
            this._branchMC.y = 25;
            addChild(this._branchMC);
            this._activationBtn = ComponentFactory.Instance.creat("lightRoad.Gift.activation.btn");
            addChild(this._activationBtn);
            this._activationBtn.addEventListener(MouseEvent.CLICK,this.__activation);
            this._numberText.text = _loc3_ + "/" + this._GiftMessage.Count;
         }
         else
         {
            this._baseCell.filters = [ComponentFactory.Instance.model.getSet("grayFilter")];
            this._numberText.text = _loc3_ + "/" + this._GiftMessage.Count;
         }
      }
      
      private function __draw(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LightRoadManager.instance.DrawThings(this._GiftMessage.Space);
      }
      
      private function __activation(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         LightRoadManager.instance.DrawThings(this._GiftMessage.Space);
      }
      
      protected function creatItemCell(param1:int = 50) : BaseCell
      {
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,param1,param1);
         _loc2_.graphics.endFill();
         var _loc3_:BaseCell = new BaseCell(_loc2_,null,true,true);
         _loc3_.tipDirctions = "1,5,4,0,3,7,6,2";
         _loc3_.tipGapV = 10;
         _loc3_.tipGapH = 10;
         _loc3_.tipStyle = "core.GoodsTip";
         return _loc3_;
      }
      
      public function GetTemplateInfo(param1:int) : ItemTemplateInfo
      {
         return ItemManager.Instance.getTemplateById(param1);
      }
      
      private function removeActivationBtn() : void
      {
         if(this._activationBtn)
         {
            this._activationBtn.removeEventListener(MouseEvent.CLICK,this.__activation);
            ObjectUtils.disposeObject(this._activationBtn);
            this._activationBtn = null;
         }
      }
      
      private function removeDrawBtn() : void
      {
         if(this._drawBtn)
         {
            this._drawBtn.removeEventListener(MouseEvent.CLICK,this.__draw);
            ObjectUtils.disposeObject(this._drawBtn);
            this._drawBtn = null;
         }
      }
      
      private function removeBranchMC() : void
      {
         if(this._branchMC)
         {
            ObjectUtils.disposeObject(this._branchMC);
            this._branchMC = null;
         }
      }
      
      private function removeNumberMC() : void
      {
         if(this._numberText)
         {
            ObjectUtils.disposeObject(this._numberText);
            this._numberText = null;
         }
      }
      
      private function removeMaskMC() : void
      {
         if(this._MaskMC)
         {
            ObjectUtils.disposeObject(this._MaskMC);
            this._MaskMC = null;
         }
      }
      
      private function disposeCell() : void
      {
         this.removeBranchMC();
         if(this._baseCell)
         {
            ObjectUtils.disposeObject(this._baseCell);
            this._baseCell = null;
         }
         this.removeMaskMC();
         this.removeActivationBtn();
         this.removeDrawBtn();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.disposeCell();
      }
   }
}
