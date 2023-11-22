@group(0)
@binding(0)
var<storage, read_write> storage_buffer: array<u32>;

@compute
@workgroup_size(128)
fn main(
    @builtin(global_invocation_id) global_id: vec3<u32>,
    @builtin(num_subgroups) num_subgroups: u32,
    @builtin(subgroup_id) subgroup_id: u32,
    @builtin(subgroup_size) subgroup_size: u32,
    @builtin(subgroup_invocation_id) subgroup_invocation_id: u32,
) {
    var passed = 0u;

    mask = 1u << 0u;
    if subgroup_invocation_id % 2u == 0u {
        let sum = subgroupAdd(1u);
        passed = sum;
        // passed |= mask * u32(sum == (subgroup_size / 2u));
    } else {
        // passed |= mask * u32(subgroupAdd(1u) == (subgroup_size / 2u));
        passed = subgroup_size / 2u;
    }

    mask = 1u << 1u;
    switch subgroup_invocation_id % 3u {
        case 0u: {
            // passed |= mask * u32(subgroupBroadcastFirst(subgroup_invocation_id) == 0u);
        }
        case 1u: {
            // passed |= mask * u32(subgroupBroadcastFirst(subgroup_invocation_id) == 1u);
        }
        case 2u: {
            // passed |= mask * u32(subgroupBroadcastFirst(subgroup_invocation_id) == 2u);
        }
        default {  }
    }

    // Increment TEST_COUNT in subgroup_operations/mod.rs if adding more tests

    storage_buffer[global_id.x] = passed;
}
