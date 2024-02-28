module myNft::puppy{
    use std::string::{utf8,String};
    use sui::object;
    use sui::package;
    use sui::display;
    use sui::object::{UID};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;

    struct PUPPY has drop {}

    struct OwnPuppy has key, store {
        id : UID,
        name : String,
        image_url : String,
        description: String
    }

    fun init(witness : PUPPY,
        ctx: &mut TxContext
    ) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"image_url"),
            utf8(b"description")
        ];

        let values = vector[
            utf8(b"{name}"),
            utf8(b"{image_url}"),
            utf8(b"{description}"),
        ];

        let publisher = package::claim(witness, ctx);
        let display = display::new_with_fields<OwnPuppy>(&publisher,keys,values,ctx);
        display::update_version(&mut display);

        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(display, tx_context::sender(ctx));



    }

    public entry fun mint(name : vector<u8>, img_url : vector<u8>, des :vector<u8>, ctx : &mut TxContext){
        let op = OwnPuppy{
            id : object::new(ctx),
            name: utf8(name),
            image_url : utf8(img_url),
            description : utf8(des)
        };

        transfer::transfer(op, tx_context::sender(ctx));
    }

    public entry fun editUrl(puppy : &mut OwnPuppy, url : String){
        puppy.image_url = url
    }

    public entry fun editName(puppy : &mut OwnPuppy, name : String){
        puppy.name = name
    }

    public entry fun editDesc(puppy : &mut OwnPuppy, desc : String){
        puppy.description = desc
    }

}