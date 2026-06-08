#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

namespace_imports = [
    'device/essential/gem',
    'hardware/qcom-caf/sm8150',
    'hardware/qcom-caf/wlan',
    'vendor/qcom/opensource/commonsys/display',
    'vendor/qcom/opensource/commonsys-intf/display',
    'vendor/qcom/opensource/dataservices',
    'vendor/qcom/opensource/display',
]

blob_fixups: blob_fixups_user_type = {
    'system_ext/etc/permissions/qcrilhook.xml': blob_fixup()
        .regex_replace('/system/', '/system_ext/'),
    (
        'vendor/bin/cnd',
        'vendor/bin/imsdatadaemon',
        'vendor/lib64/libril-qc-hal-qmi.so',
    ): blob_fixup()
        .add_needed('libhidlbase-v32.so'),
    (
        'vendor/bin/vppservice',
        'vendor/lib/libvppclient.so',
    ): blob_fixup()
        .remove_needed('libhwbinder.so'),
    'vendor/lib/hw/audio.primary.gem.so': blob_fixup()
        .replace_needed('libaudioroute.so', 'libaudioroute-v34.so'),
    'vendor/lib64/hw/camera.qcom.so': blob_fixup()
        .add_needed('libcomparetf2_shim.so'),
    'vendor/lib64/libdpps.so': blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),
    'vendor/lib64/liboemcrypto.so': blob_fixup()
        .remove_needed('libcommoncputils.so'),
    'vendor/lib64/libvidhance.so': blob_fixup()
        .add_needed('libcomparetf2_shim.so')
        .add_needed('libdemangle.so'),
    (
        'vendor/lib64/libwvhidl.so',
        'vendor/lib64/mediadrm/libwvdrmengine.so',
    ): blob_fixup()
        .add_needed('libcrypto_shim.so'),
    ## TEMP ##
    (
        'vendor/lib64/com.quicinc.cne.api@1.0.so',
        'vendor/lib64/com.quicinc.cne.api@1.1.so',
        'vendor/lib64/com.quicinc.cne.server@2.0.so',
        'vendor/lib64/com.quicinc.cne.server@2.1.so',
        'vendor/lib64/com.quicinc.cne.server@2.2.so',
        'vendor/lib64/com.quicinc.cne.server@2.3.so',
        'vendor/lib64/vendor.qti.hardware.data.qmi@1.0.so',
    ): blob_fixup()
        .add_needed('libhidlbase_shim.so'),
}  # fmt: skip

module = ExtractUtilsModule(
    'gem',
    'essential',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
