package petsBag.view.item
{
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.display.BitmapLoaderProxy;
   import ddt.interfaces.IAcceptDrag;
   import ddt.interfaces.IDragable;
   import ddt.manager.DragManager;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.tips.ToolPropInfo;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import pet.date.PetSkill;
   import pet.date.PetSkillTemplateInfo;
   import petsBag.controller.PetBagController;
   import petsBag.event.PetItemEvent;
   import trainer.data.ArrowType;
   
   public class SkillItem extends Component implements IDragable, IAcceptDrag
   {
      
      public static const ZOOMVALUE:Number = 0.5;
       
      
      protected var _info:PetSkillTemplateInfo;
      
      protected var _skillIcon:DisplayObject;
      
      protected var _iconPos:Point;
      
      private var _isLock:Boolean;
      
      private var _lockImg:DisplayObject;
      
      private var _lockLvImg:DisplayObject;
      
      protected var _index:int;
      
      protected var _canDrag:Boolean;
      
      protected var _isWatch:Boolean;
      
      protected var _tipInfo:ToolPropInfo;
      
      protected var _mask:Shape;
      
      protected var _bg:DisplayObject;
      
      protected var _quickShortKey:Bitmap;
      
      public var DoubleClickEnabled:Boolean = false;
      
      private var _skillID:int = -1;
      
      public function SkillItem(param1:PetSkillTemplateInfo, param2:int, param3:Boolean = false, param4:Boolean = false)
      {
         super();
         this._canDrag = param3;
         this._isWatch = param4;
         this._index = param2;
         this._info = param1;
         this._iconPos = new Point();
         this.initView();
         this.initEvent();
      }
      
      public function set skillID(param1:int) : void
      {
         this.info = null;
         this._skillID = param1;
         ShowTipManager.Instance.removeTip(this);
         if(param1 < 0)
         {
            this.isLock = true;
         }
         else if(param1 == 0)
         {
            this.isLock = false;
         }
         else
         {
            this.info = new PetSkill(param1);
            ShowTipManager.Instance.addTip(this);
         }
      }
      
      override public function get tipStyle() : String
      {
         return "ddt.view.tips.PetSkillCellTip";
      }
      
      override public function get tipData() : Object
      {
         return this._info;
      }
      
      public function get skillID() : int
      {
         return this._skillID;
      }
      
      public function get iconPos() : Point
      {
         return this._iconPos;
      }
      
      public function set iconPos(param1:Point) : void
      {
         this._iconPos = param1;
         this.updateSize();
      }
      
      protected function initView() : void
      {
         if(this._canDrag)
         {
            this._bg = ComponentFactory.Instance.creatCustomObject("petsBag.skillItemBG");
            addChild(this._bg);
         }
         tipDirctions = "5,2,7,1,6,4";
         tipGapH = 20;
         tipGapV = 20;
         graphics.beginFill(16711680,0);
         graphics.drawCircle(17.5,17.5,17);
         graphics.endFill();
         this._mask = new Shape();
         this._mask.graphics.beginFill(16711680,0);
         this._mask.graphics.drawCircle(17.5,17.5,17);
         this._mask.graphics.endFill();
         this._mask.visible = !this._canDrag;
         this.buttonMode = true;
         if(this._index == 4)
         {
            this._lockImg = ComponentFactory.Instance.creat("assets.petsBag.lock");
         }
         else
         {
            this._lockImg = ComponentFactory.Instance.creat("assets.petsBag.lockLv");
         }
         addChild(this._lockImg);
         this._lockImg.visible = !this._canDrag;
         if(this._info)
         {
            this._skillIcon = new BitmapLoaderProxy(PathManager.solveSkillPicUrl(this._info.Pic));
            addChild(this._skillIcon);
            this._lockImg.visible = false;
            this.updateSize();
         }
         this.addQuictShortKey();
      }
      
      protected function initEvent() : void
      {
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
      }
      
      protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if(!this.DoubleClickEnabled)
         {
            return;
         }
         SoundManager.instance.play("008");
         if(this.info == null)
         {
            return;
         }
         dispatchEvent(new PetItemEvent(PetItemEvent.ITEM_CLICK,this));
      }
      
      protected function __clickHandler(param1:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._canDrag && this._info && !this._isWatch)
         {
            DragManager.startDrag(this,null,this.creatDragImg(),stage.mouseX,stage.mouseY,DragEffect.MOVE);
         }
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
      }
      
      public function updateSize() : void
      {
         if(this._skillIcon)
         {
            this._skillIcon.x = this._iconPos.x;
            this._skillIcon.y = this._iconPos.y;
            if(this._canDrag)
            {
               this._skillIcon.scaleX = this._skillIcon.scaleY = SkillItem.ZOOMVALUE;
            }
         }
      }
      
      public function set isLock(param1:Boolean) : void
      {
         this._isLock = param1;
         this.grayFilters = this._isLock;
         this._lockImg.visible = this._isLock;
         if(this._quickShortKey)
         {
            this._quickShortKey.visible = !this._isLock;
         }
      }
      
      public function get isLock() : Boolean
      {
         return this._isLock;
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         this._index = param1;
      }
      
      public function get info() : PetSkillTemplateInfo
      {
         return this._info;
      }
      
      public function set info(param1:PetSkillTemplateInfo) : void
      {
         this._info = param1;
         ObjectUtils.disposeObject(this._skillIcon);
         this._skillIcon = null;
         _tipData = null;
         if(this._info)
         {
            this.isLock = false;
            this._skillIcon = new BitmapLoaderProxy(PathManager.solveSkillPicUrl(this._info.Pic),new Rectangle(0,0,35,35));
            this._skillIcon.mask = this._mask;
            addChild(this._skillIcon);
            addChild(this._mask);
            this.addQuictShortKey();
            this.updateSize();
         }
      }
      
      protected function addQuictShortKey() : void
      {
         if(!this._canDrag && !this._quickShortKey && !this._isLock)
         {
            this._quickShortKey = ComponentFactory.Instance.creatBitmap("assets.petsBag.Q" + this._index.toString());
            addChild(this._quickShortKey);
         }
      }
      
      public function set grayFilters(param1:Boolean) : void
      {
         if(param1)
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
         else
         {
            filters = null;
         }
      }
      
      public function getSource() : IDragable
      {
         return this;
      }
      
      public function dragStop(param1:DragEffect) : void
      {
         SoundManager.instance.play("008");
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:SkillItem = param1.source as SkillItem;
         if(_loc2_ && !this._canDrag)
         {
            SocketManager.Instance.out.sendEquipPetSkill(PetBagController.instance().petModel.currentPetInfo.Place,_loc2_.info.ID,this._index);
            if(PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.CHOOSE_PET_SKILL] > 0)
            {
               PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.CHOOSE_PET_SKILL);
               PetBagController.instance().petModel.petGuildeOptionOnOff[ArrowType.CHOOSE_PET_SKILL] = 0;
            }
         }
      }
      
      protected function creatDragImg() : DisplayObject
      {
         var _loc1_:Bitmap = null;
         _loc1_ = new Bitmap(new BitmapData(this._skillIcon.width / this._skillIcon.scaleX,this._skillIcon.height / this._skillIcon.scaleY,true,4294967295));
         _loc1_.bitmapData.draw(this._skillIcon);
         _loc1_.scaleX = 0.75;
         _loc1_.scaleY = 0.75;
         return _loc1_;
      }
      
      override public function get height() : Number
      {
         return !!Boolean(this._bg) ? Number(Number(this._bg.height)) : Number(Number(0));
      }
      
      override public function get width() : Number
      {
         return !!Boolean(this._bg) ? Number(Number(this._bg.width)) : Number(Number(0));
      }
      
      override public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         ObjectUtils.disposeObject(this._skillIcon);
         this._skillIcon = null;
         ObjectUtils.disposeObject(this._lockImg);
         this._lockImg = null;
         ObjectUtils.disposeObject(this._lockLvImg);
         this._lockLvImg = null;
         this._info = null;
         this._index = 0;
         ObjectUtils.disposeAllChildren(this);
         super.dispose();
      }
   }
}
