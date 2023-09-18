using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }


RecipeIndex:= class<concrete>():

    @editable
    Food : creative_prop = creative_prop{}
    @editable
    MutatorZonePickUp: mutator_zone_device = mutator_zone_device{}
    @editable
    OriginalFoodPos: vector3 = vector3{}
    @editable
    DeliveryMutatorZone: mutator_zone_device = mutator_zone_device{}

    
    var _playerhasfood : logic = false

    var _breaktheloop : logic = false


    FoodFollowsPlayer(Agent:agent)<suspends>:void=
        if(_breaktheloop = false):
            loop:
                Sleep(0.1)
                if (_breaktheloop=false):
                    if(FortCharacter:=Agent.GetFortCharacter[]):
                        PlayerPos :vector3= FortCharacter.GetTransform().Translation
                        MovePos:=PlayerPos
                        DebbyPos := Food.GetTransform().Translation
                        DistanceFromPlayer := Distance(PlayerPos, DebbyPos)
                        Time := DistanceFromPlayer / 600.0
                        Food.MoveTo(PlayerPos, rotation{}, Time)
                else:
                    break
    

        

    SpawnFunction(Agent:agent):void=
        spawn:
            FoodFollowsPlayer(Agent)
        set _playerhasfood = true


    DeliveryFood(Agent:agent)<suspends>:void=
        if(_playerhasfood?):
            set _breaktheloop = true
            if(Food.TeleportTo[OriginalFoodPos, rotation{}]):
                set _playerhasfood = false
                set _breaktheloop = true
                Sleep(5.0)
                set _breaktheloop = false

    DeliverySubs(Agent:agent):void=
        spawn:
            DeliveryFood(Agent)

               

    Init():void=
        MutatorZonePickUp.AgentEntersEvent.Subscribe(SpawnFunction)
        DeliveryMutatorZone.AgentEntersEvent.Subscribe(DeliverySubs)




    # Subscribe(Agent:agent):void=
    #     MutatorToPickup.AgentEntersEvent.Subscribe(Init)



FoodDevice := class(creative_device):
    @editable
    var FoodIndex :[]RecipeIndex = array{}
    

    OnBegin<override>()<suspends>:void=
        for(FoodIndexs: FoodIndex):
            FoodIndexs.Init()

      

  

      

