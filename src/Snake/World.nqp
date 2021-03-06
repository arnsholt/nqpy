class Snake::World is HLL::World;

use Snake::ModuleLoader;

method load_setting($name) {
    if $name ne "NULL" {
        my $setting := Snake::ModuleLoader.load_setting($name);

        my $set_outer := QAST::Op.new(:op<forceouterctx>,
            QAST::BVal.new(:value($*UNIT)),
            QAST::Op.new(:op<callmethod>, :name<load_setting>,
                QAST::Op.new(:op<getcurhllsym>,
                    QAST::SVal.new(:value<ModuleLoader>)
                ),
                QAST::SVal.new(:value($name)),
            ),
        );
        if self.is_precompilation_mode() {
            # TODO
            nqp::die("World.load_setting for precompilation NYI");
        }
        else {
            self.add_fixup_task(:fixup_ast($set_outer));
        }


        nqp::ctxlexpad($setting);
    }
}

# vim: ft=perl6
